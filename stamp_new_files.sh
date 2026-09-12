#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

declare -a ADD=()
count=0

while IFS= read -r -d '' f; do
    case "$f" in
        *.sha256|*.ots) continue ;;
    esac

    sha="$f.sha256"
    ots="$f.ots"

    # Already publicly committed in Git: leave it completely alone.
    if git cat-file -e "HEAD:$sha" 2>/dev/null &&
       git cat-file -e "HEAD:$ots" 2>/dev/null; then
        continue
    fi

    # Never publish the source itself.
    if git ls-files --error-unmatch "$f" >/dev/null 2>&1; then
        echo "ERROR: source is tracked by git: $f"
        exit 1
    fi

    echo "NEW: $f"

    # Create SHA-256 only if absent.
    if [[ ! -f "$sha" ]]; then
        (
            cd "$(dirname "$f")"
            sha256sum "$(basename "$f")" > "$(basename "$f").sha256"
        )
        echo "  created $sha"
    else
        echo "  exists  $sha"
    fi

    # ots stamp submits the commitment to OpenTimestamps calendars.
    if [[ ! -f "$ots" ]]; then
        ots stamp "$f"
        echo "  submitted to OpenTimestamps calendars: $ots"
    else
        echo "  exists  $ots (already stamped)"
        ots upgrade "$ots" || true
    fi

    ADD+=("$sha" "$ots")
    count=$((count + 1))
done < <(
    find files -type f \
        ! -name '*.sha256' \
        ! -name '*.ots' \
        -print0
)

if (( count == 0 )); then
    echo "No new files."
    exit 0
fi

git add stamp_new_files.sh "${ADD[@]}"

echo
git status --short
echo

git commit -m "Add new proof commitments"
git push origin main

echo
echo "OpenTimestamps status:"
for f in "${ADD[@]}"; do
    [[ "$f" == *.ots ]] || continue
    echo "---- $f"
    ots verify "$f" || true
done
