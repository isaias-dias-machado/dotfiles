#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/helpers.sh"

link_file "$DOTFILES_HOME/home/.bashrc" "$HOME/.bashrc"
