#!/usr/bin/env bash
set -uo pipefail
DOTFILES_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

fail=0
check() {
  local source="$1" target="$2"
  if [ ! -L "$target" ]; then
    printf 'MISSING  %s\n' "$target"; fail=1; return
  fi
  if [ "$(readlink -f "$target")" != "$(readlink -f "$source")" ]; then
    printf 'WRONG    %s -> %s\n' "$target" "$(readlink "$target")"; fail=1; return
  fi
  printf 'ok       %s\n' "$target"
}

check "$DOTFILES_HOME/home/.bashrc"        "$HOME/.bashrc"
check "$DOTFILES_HOME/home/bashrc.d"       "$HOME/.bashrc.d"
check "$DOTFILES_HOME/home/.vimrc"         "$HOME/.vimrc"
check "$DOTFILES_HOME/home/.gitignore"     "$HOME/.gitignore"
check "$DOTFILES_HOME/home/.tmux.conf"     "$HOME/.tmux.conf"
check "$DOTFILES_HOME/home/.tool-versions" "$HOME/.tool-versions"
check "$DOTFILES_HOME/home/.clang-format"  "$HOME/.clang-format"
check "$DOTFILES_HOME/config/vim"          "$HOME/.vim"
check "$DOTFILES_HOME/config/nvim"         "$HOME/.config/nvim"
check "$DOTFILES_HOME/config/kitty"        "$HOME/.config/kitty"
check "$DOTFILES_HOME/config/zellij"       "$HOME/.config/zellij"
check "$DOTFILES_HOME/config/opencode/AGENTS.md"      "$HOME/.config/opencode/AGENTS.md"
check "$DOTFILES_HOME/config/opencode/opencode.jsonc" "$HOME/.config/opencode/opencode.jsonc"
check "$DOTFILES_HOME/config/opencode/cli.json"       "$HOME/.config/opencode/cli.json"
check "$DOTFILES_HOME/config/opencode/skills"         "$HOME/.config/opencode/skills"
check "$DOTFILES_HOME/config/vscodium/settings.json"   "$HOME/.config/VSCodium/User/settings.json"
check "$DOTFILES_HOME/config/vscodium/keybindings.json" "$HOME/.config/VSCodium/User/keybindings.json"
check "$DOTFILES_HOME/scripts"             "$HOME/scripts"

# ~/.gitconfig is generated, not a symlink.
if ! grep -q "path = $DOTFILES_HOME/home/.gitconfig" "$HOME/.gitconfig" 2>/dev/null; then
  printf 'MISSING  include of home/.gitconfig in ~/.gitconfig\n'; fail=1
fi
if [ ! -e "$HOME/.gitconfig.local" ]; then
  printf 'MISSING  ~/.gitconfig.local\n'; fail=1
fi

exit "$fail"
