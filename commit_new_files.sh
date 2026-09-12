#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

while IFS= read -r -d '' f; do
    sha="$f.sha256"
    ots="$f.ots"

    # Never publish the private source itself.
    if git ls-files --error-unmatch "$f" >/dev/null 2>&1; then
        echo "ERROR: private source is tracked by git: $f"
        exit 1
    fi

    # Existing SHA commitments are verified and never silently replaced.
    if [[ -f "$sha" ]]; then
        expected=$(awk '{print $1}' "$sha")
        actual=$(sha256sum "$f" | awk '{print $1}')

        if [[ "$expected" != "$actual" ]]; then
            echo "ERROR: existing SHA-256 commitment does not match: $f"
            echo "expected: $expected"
            echo "actual:   $actual"
            echo "Use a new filename/version rather than overwriting a committed source."
            exit 1
        fi

        echo "verified: $sha"
    else
        (
            cd "$(dirname "$f")"
            sha256sum "$(basename "$f")" > "$(basename "$f").sha256"
        )
        echo "created:  $sha"
    fi

    # `ots stamp` creates the .ots file AND immediately submits the
    # commitment to the OpenTimestamps calendar servers.
    if [[ -f "$ots" ]]; then
        echo "exists:   $ots"
    else
        echo "stamping and submitting to OpenTimestamps calendars: $f"
        ots stamp "$f"

        [[ -f "$ots" ]] || {
            echo "ERROR: OpenTimestamps did not create $ots"
            exit 1
        }

        echo "submitted: $ots"
    fi
done < <(
    find files -type f \
        ! -name '*.sha256' \
        ! -name '*.ots' \
        -print0
)

# README contains links to commitment artifacts, not raw hashes.
python3 <<'PY'
from pathlib import Path

p = Path("README.md")
text = p.read_text(encoding="utf-8")

begin = "<!-- BEGIN AUTO FILE LINKS -->"
end = "<!-- END AUTO FILE LINKS -->"

rows = []
for sha in sorted(Path("files").rglob("*.sha256")):
    source = Path(str(sha)[:-7])
    ots = Path(str(source) + ".ots")

    line = f"- **{source.name}**: [SHA-256 commitment]({sha.as_posix()})"
    if ots.exists():
        line += f" · [OpenTimestamps proof]({ots.as_posix()})"
    rows.append(line)

block = (
    f"{begin}\n\n"
    "## Commitment files\n\n"
    + "\n".join(rows)
    + f"\n\n{end}"
)

if begin in text and end in text:
    before = text.split(begin, 1)[0].rstrip()
    after = text.split(end, 1)[1].lstrip()
    text = before + "\n\n" + block
    if after:
        text += "\n\n" + after
else:
    text = text.rstrip() + "\n\n" + block + "\n"

p.write_text(text, encoding="utf-8")
PY

git add .gitignore README.md commit_new_files.sh stamp_new_files.sh

find files -type f \( -name '*.sha256' -o -name '*.ots' \) -print0 |
    xargs -0 -r git add

echo
git status --short
echo

if git diff --cached --quiet; then
    echo "Nothing new to commit."
    exit 0
fi

git commit -m "Update proof commitments"
git push origin main

echo
echo "New .ots files were submitted to OpenTimestamps calendars by 'ots stamp'."
echo "Bitcoin anchoring may still be pending."
