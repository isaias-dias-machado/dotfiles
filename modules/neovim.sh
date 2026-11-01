#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/helpers.sh"

# lazy.nvim installs plugins into ~/.local/share/nvim/lazy on first launch;
# nothing to clone here.
link_file "$DOTFILES_HOME/config/nvim" "$HOME/.config/nvim"
