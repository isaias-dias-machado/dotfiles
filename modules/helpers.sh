#!/usr/bin/env bash
# Shared functions. Sourced by modules; never executed directly.
set -euo pipefail

_helpers_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_HOME="${DOTFILES_HOME:-$(dirname "$_helpers_dir")}"
export DOTFILES_HOME

DRY_RUN="${DRY_RUN:-0}"
BACKUP_ROOT="$HOME/.dotfiles-backup"
BACKUP_DIR="${BACKUP_DIR:-$BACKUP_ROOT/$(date +%Y-%m-%dT%H:%M:%S)}"
export BACKUP_DIR

say() { printf '%s\n' "$*"; }

run() {
  if [ "$DRY_RUN" = "1" ]; then
    printf 'DRY:'; printf ' %q' "$@"; printf '\n'
  else
    "$@"
  fi
}

write_file() {
  local target="$1" content="$2"
  if [ "$DRY_RUN" = "1" ]; then
    say "DRY: write $target"
  else
    printf '%s' "$content" > "$target"
  fi
}

# link_file SOURCE TARGET
link_file() {
  local source="$1" target="$2"

  if [ ! -e "$source" ]; then
    printf 'ERROR: source does not exist: %s\n' "$source" >&2
    return 1
  fi

  case "$target" in
    "$HOME"/*) ;;
    *) printf 'ERROR: target outside $HOME: %s\n' "$target" >&2; return 1 ;;
  esac

  # Already the right link: nothing to do.
  if [ -L "$target" ] && [ -e "$target" ] &&
     [ "$(readlink -f "$target")" = "$(readlink -f "$source")" ]; then
    say "ok   $target"
    return 0
  fi

  # Back up anything that exists: file, directory, or symlink.
  if [ -e "$target" ] || [ -L "$target" ]; then
    local rel="${target#"$HOME"/}"
    local saved="$BACKUP_DIR/$rel"
    say "bak  $target -> $saved"
    run mkdir -p "$(dirname "$saved")"
    run mv "$target" "$saved"
  fi

  run mkdir -p "$(dirname "$target")"
  say "link $target -> $source"
  # `ln -s`, never `ln -sf`: if anything is still at $target, fail loudly
  # instead of creating the link inside a directory.
  run ln -s "$source" "$target"
}
