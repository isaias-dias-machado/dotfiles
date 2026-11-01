#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/helpers.sh"

link_file "$DOTFILES_HOME/home/.tool-versions" "$HOME/.tool-versions"
link_file "$DOTFILES_HOME/home/.clang-format" "$HOME/.clang-format"
