#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/helpers.sh"

# File-level links only: ~/.config/opencode also holds deepseek.key,
# service.json and node_modules/, which must never be linked into the repo.
link_file "$DOTFILES_HOME/config/opencode/AGENTS.md"      "$HOME/.config/opencode/AGENTS.md"
link_file "$DOTFILES_HOME/config/opencode/opencode.jsonc" "$HOME/.config/opencode/opencode.jsonc"
link_file "$DOTFILES_HOME/config/opencode/cli.json"       "$HOME/.config/opencode/cli.json"
link_file "$DOTFILES_HOME/config/opencode/skills"         "$HOME/.config/opencode/skills"
