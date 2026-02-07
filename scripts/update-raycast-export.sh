#!/usr/bin/env bash
set -euo pipefail

scripts_dir="$(
  cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
  pwd
)"
repo_root="$scripts_dir/.."

_die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

src="${1:-}"
if [[ -z "$src" ]]; then
  _die "usage: ./scripts/update-raycast-export.sh /path/to/rayconfig"
fi

if [[ ! -f "$src" ]]; then
  _die "file not found: $src"
fi

dest="$repo_root/rayconfig"
cp -f "$src" "$dest"

printf '%s\n' "Updated $dest"
