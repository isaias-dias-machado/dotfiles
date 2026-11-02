# 70-tools.sh - Tool paths and tool-specific aliases
# Guard: only load if tools are available

# ASDF shims
if [ -d "${ASDF_DATA_DIR:-$HOME/.asdf}/shims" ]; then
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

# Krew binaries
if [ -n "${KREW_ROOT:-}" ] && [ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]; then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# Go
if [ -d "/usr/local/go/bin" ]; then
  export PATH="/usr/local/go/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ]; then
  export PATH="$HOME/go/bin:$PATH"
fi

# NPM global binaries
if [ -d "$HOME/.npm-global/bin" ]; then
  export PATH="$HOME/.npm-global/bin:$PATH"
fi

# Scripts directory
if [ -d "$HOME/scripts" ]; then
  export PATH="$HOME/scripts:$PATH"
fi

# Mestrado scripts (optional, machine-specific)
if [ -d "$HOME/mestrado/cp/scripts" ]; then
  export PATH="$HOME/mestrado/cp/scripts:$PATH"
fi

# Neovim alias
alias vi="nvim"

# Zellij
if command -v zellij >/dev/null 2>&1; then
  alias z='zellij'
fi

# Opencode alias
if command -v opencode >/dev/null 2>&1; then
  alias oc='opencode'
  alias codex='codex --dangerously-bypass-approvals-and-sandbox'
fi

# CMake aliases
alias cmakeB="cmake -B build"
alias cmakeb="cmake --build build"

# Rust/Cargo
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# SDKMAN
if [ -d "$HOME/.sdkman" ]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# Clipboard
if command -v xclip >/dev/null 2>&1; then
  alias clip='xclip -selection clipboard'
fi

# Database alias (machine-specific, will be in .bashrc.local)
# alias db="psql -d $CUR_DATABASE"
# alias droptestdb="MIX_ENV=test mix ecto.drop"

# Misc tool aliases
alias key='cat $HOME/.secrets/key | clip.exe'
alias sup='vi ~/suporte/apontamentos.md'
alias wiki='vi ~/wiki.md'

# Deucalion SSH shortcut (machine-specific)
# alias deucalion="kitty +kitten ssh deucalion"
