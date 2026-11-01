#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/helpers.sh"

link_file "$DOTFILES_HOME/home/.gitignore" "$HOME/.gitignore"

# ~/.gitconfig is generated, not linked: `git config --global` writes here, and
# a symlink into the repo would drag the identity (email) into the repo.
if [ -L "$HOME/.gitconfig" ] || [ ! -e "$HOME/.gitconfig" ]; then
  if [ -L "$HOME/.gitconfig" ]; then
    run mkdir -p "$BACKUP_DIR"
    run mv "$HOME/.gitconfig" "$BACKUP_DIR/.gitconfig"
  fi
  write_file "$HOME/.gitconfig" "[include]
	path = $DOTFILES_HOME/home/.gitconfig
[include]
	path = $HOME/.gitconfig.local
"
fi

if [ ! -e "$HOME/.gitconfig.local" ]; then
  write_file "$HOME/.gitconfig.local" "# Machine-local identity. Never commit.
[user]
	name =
	email =
"
fi
