#!/usr/bin/env bash
set -euo pipefail

script_dir="$(
  cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
  pwd
)"

usage() {
  cat <<'USAGE'
Usage:
  ./bootstrap-mac.sh [--skip-vscode] [--skip-raycast-import]

Runs a one-shot macOS bootstrap:
- Ensures Xcode CLT + Homebrew
- Installs Brewfile (formula + cask) and optionally VS Code extensions
- Applies dotfiles via chezmoi using this repo as the source
- Installs oh-my-zsh (required by the provided zshrc)
- Installs tools via mise (if available)

Options:
  --skip-vscode           Skip VS Code extensions even if `code` is available
  --skip-raycast-import   Don't copy/open the bundled Raycast export file
  -h, --help              Show this help
USAGE
}

log() {
  printf '%s\n' "$*"
}

die() {
  log "error: $*"
  exit 1
}

skip_vscode=0
skip_raycast_import=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --skip-vscode)
      skip_vscode=1
      shift
      ;;
    --skip-raycast-import)
      skip_raycast_import=1
      shift
      ;;
    *)
      die "unknown arg: $1 (use --help)"
      ;;
  esac
done

require_macos() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    die "this script is for macOS only"
  fi
}

ensure_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    return
  fi

  log "Installing Xcode Command Line Tools (required for Homebrew)."
  xcode-select --install >/dev/null 2>&1 || true
  die "finish the GUI install, then re-run: $0"
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  log "Installing Homebrew."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

ensure_brew_shellenv() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  if [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  if ! command -v brew >/dev/null 2>&1; then
    die "brew not found after install"
  fi
}

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    return
  fi

  if ! command -v git >/dev/null 2>&1; then
    die "git not found (Xcode CLT install might not be finished)"
  fi

  log "Installing oh-my-zsh."
  git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
}

bundle_install() {
  log "Updating Homebrew."
  brew update

  log "Installing Brewfile (tap/formula/cask)."
  brew bundle install --file "$script_dir/Brewfile" --tap --formula --cask

  if [[ "$skip_vscode" -eq 1 ]]; then
    return
  fi

  if command -v code >/dev/null 2>&1; then
    log "Installing VS Code extensions from Brewfile."
    brew bundle install --file "$script_dir/Brewfile" --vscode
    return
  fi

  log "Skipping VS Code extensions (code CLI not found)."
  log "After installing VS Code and enabling 'code' in PATH, run:"
  log "  brew bundle install --file \"$script_dir/Brewfile\" --vscode"
}

ensure_chezmoi() {
  if command -v chezmoi >/dev/null 2>&1; then
    return
  fi

  log "Installing chezmoi."
  brew install chezmoi
}

ensure_chezmoi_config() {
  local cfg_dir="$HOME/.config/chezmoi"
  local cfg="$cfg_dir/chezmoi.toml"

  mkdir -p "$cfg_dir"

  if [[ -f "$cfg" ]]; then
    if grep -q '^sourceDir\s*=\s*' "$cfg"; then
      return
    fi

    log "Configuring chezmoi sourceDir (append)."
    printf '\nsourceDir = "%s"\n' "$script_dir" >>"$cfg"
    return
  fi

  log "Configuring chezmoi sourceDir."
  printf 'sourceDir = "%s"\n' "$script_dir" >"$cfg"
}

apply_chezmoi() {
  log "Applying dotfiles with chezmoi."
  chezmoi -S "$script_dir" apply
}

raycast_import() {
  if [[ "$skip_raycast_import" -eq 1 ]]; then
    return
  fi

  local src=""
  shopt -s nullglob
  local candidates=("$script_dir"/raycast/*.rayconfig)
  shopt -u nullglob

  if [[ ${#candidates[@]} -gt 0 ]]; then
    src="$(printf '%s\n' "${candidates[@]}" | sort | tail -n 1)"
  elif [[ -f "$script_dir/rayconfig" ]]; then
    # Back-compat for older versions of this repo.
    src="$script_dir/rayconfig"
  else
    return
  fi

  if [[ -z "$src" || ! -f "$src" ]]; then
    return
  fi

  local dest="$HOME/Downloads/$(basename "$src")"
  mkdir -p "$HOME/Downloads"
  cp -f "$src" "$dest"

  if command -v open >/dev/null 2>&1; then
    # Best-effort: opening the export file usually prompts an import flow.
    open -a Raycast >/dev/null 2>&1 || true
    open "$dest" >/dev/null 2>&1 || true
  fi
}

mise_install() {
  if ! command -v mise >/dev/null 2>&1; then
    return
  fi

  log "Installing tools via mise."
  mise install
}

next_steps() {
  log ""
  log "Next steps (manual):"
  log "- Open Karabiner-Elements and allow Accessibility + Input Monitoring permissions"
  log "- Confirm Input Source shortcut is Control+Space and you have 2 input sources (ABC, 2-Set Korean)"
  log "- Raycast: import the exported .rayconfig file from $HOME/Downloads if it didn't auto-open"
}

main() {
  require_macos
  ensure_xcode_clt
  ensure_homebrew
  ensure_brew_shellenv
  bundle_install
  ensure_chezmoi
  ensure_chezmoi_config
  apply_chezmoi
  install_oh_my_zsh
  mise_install
  raycast_import
  next_steps
}

main "$@"
