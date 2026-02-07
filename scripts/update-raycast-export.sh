#!/usr/bin/env bash
set -euo pipefail

scripts_dir="$(
  cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
  pwd
)"
repo_root="$scripts_dir/.."

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

src="${1:-}"
if [[ -z "$src" ]]; then
  die "usage: ./scripts/update-raycast-export.sh /path/to/*.rayconfig"
fi

if [[ ! -f "$src" ]]; then
  die "file not found: $src"
fi

base="$(basename "$src")"
dest_dir="$repo_root/raycast"
mkdir -p "$dest_dir"

dest="$dest_dir/$base"
cp -f "$src" "$dest"

printf '%s\n' "Updated $dest"
