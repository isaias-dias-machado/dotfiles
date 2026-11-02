#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/helpers.sh"

# Link the main bashrc loader
link_file "$DOTFILES_HOME/home/.bashrc" "$HOME/.bashrc"

# Link the bashrc.d directory (modules)
link_file "$DOTFILES_HOME/home/bashrc.d" "$HOME/.bashrc.d"
