# 00-env.sh - Environment setup (runs before interactive guard)

# Source user environment file if it exists
if [ -f "$HOME/.env" ]; then
  source "$HOME/.env"
fi

# Editor and UI settings
export EDITOR="nvim"
export J2D_UISCALE=2.0
export OPENCODE_EXPERIMENTAL_OUTPUT_TOKEN_MAX=262144

# opencode path
export PATH="$HOME/.opencode/bin:$PATH"
