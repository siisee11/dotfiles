#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(
  cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
  pwd
)"

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

src="${1:-}"
if [[ -z "$src" ]]; then
  die "usage: ./scripts-update-raycast-export.sh /path/to/rayconfig"
fi

if [[ ! -f "$src" ]]; then
  die "file not found: $src"
fi

dest="$repo_dir/rayconfig"
cp -f "$src" "$dest"

printf '%s\n' "Updated $dest"
