#!/usr/bin/env bash
set -euo pipefail

# Single entry point: generate SHA/OTS commitments, submit new OTS proofs
# to OpenTimestamps calendars, update README links, commit, and push.
cd "$(dirname "$0")"
exec ./commit_new_files.sh
