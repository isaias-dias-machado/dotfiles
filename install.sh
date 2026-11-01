#!/usr/bin/env bash
set -euo pipefail

DOTFILES_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_HOME
export BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y-%m-%dT%H:%M:%S)"

modules=(shell git vim neovim tmux kitty zellij opencode vscodium scripts misc)

for module in "${modules[@]}"; do
  printf '\n== %s ==\n' "$module"
  bash "$DOTFILES_HOME/modules/$module.sh"
done

printf '\nBackups (if any): %s\n' "$BACKUP_DIR"
