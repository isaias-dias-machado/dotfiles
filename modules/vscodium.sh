#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/helpers.sh"

# File-level links only: ~/.config/VSCodium/User also holds globalStorage/,
# workspaceStorage/ and History/, which must never be linked into the repo.
link_file "$DOTFILES_HOME/config/vscodium/settings.json"           "$HOME/.config/VSCodium/User/settings.json"
link_file "$DOTFILES_HOME/config/vscodium/keybindings.json"        "$HOME/.config/VSCodium/User/keybindings.json"
link_file "$DOTFILES_HOME/config/vscodium/chatLanguageModels.json" "$HOME/.config/VSCodium/User/chatLanguageModels.json"

# Install missing extensions. This is the only network step in install.sh.
if command -v codium >/dev/null 2>&1 && [ -f "$DOTFILES_HOME/config/vscodium/extensions.txt" ]; then
  installed="$(codium --list-extensions)"
  while IFS= read -r ext; do
    [ -z "$ext" ] && continue
    if ! printf '%s\n' "$installed" | grep -Fqx "$ext"; then
      run codium --install-extension "$ext"
    fi
  done < "$DOTFILES_HOME/config/vscodium/extensions.txt"
fi
