#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

while IFS= read -r -d '' f; do
    case "$f" in
        *.sha256|*.ots) continue ;;
    esac

    if [ ! -f "$f.sha256" ]; then
        (
            cd "$(dirname "$f")"
            sha256sum "$(basename "$f")" > "$(basename "$f").sha256"
        )
        echo "created: $f.sha256"
    else
        echo "exists:  $f.sha256"
    fi

    if [ ! -f "$f.ots" ]; then
        ots stamp "$f"
        echo "created: $f.ots"
    else
        echo "exists:  $f.ots"
    fi
done < <(find files -type f -print0)

python3 <<'PY'
from pathlib import Path

p = Path("README.md")
text = p.read_text()

begin = "<!-- BEGIN AUTO COMMITMENTS -->"
end = "<!-- END AUTO COMMITMENTS -->"

rows = []
for sha in sorted(Path("files").rglob("*.sha256")):
    h = sha.read_text().split()[0]
    original = str(sha)[:-7]
    rows.append(f"{h}  {original}")

block = (
    begin + "\n\n"
    "## Additional cryptographic commitments\n\n"
    "SHA-256 commitments generated for files held privately/local to this repository checkout:\n\n"
    + "\n".join(rows) +
    "\n\nCorresponding `.ots` files are OpenTimestamps proofs.\n\n"
    + end
)

if begin in text and end in text:
    before = text.split(begin, 1)[0].rstrip()
    after = text.split(end, 1)[1].lstrip()
    text = before + "\n\n" + block
    if after:
        text += "\n\n" + after
else:
    text = text.rstrip() + "\n\n" + block + "\n"

p.write_text(text)
PY

git add .gitignore commit_new_files.sh README.md

find files -type f \( -name '*.sha256' -o -name '*.ots' \) -print0 |
    xargs -0 git add

git status --short

if git diff --cached --quiet; then
    echo "Nothing new to commit."
else
    git commit -m "Update proof commitments"
    git push origin main
fi
