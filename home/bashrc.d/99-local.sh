# 99-local.sh - Load per-machine configuration
# This file sources ~/.bashrc.local if it exists

if [ -f "$HOME/.bashrc.local" ]; then
  source "$HOME/.bashrc.local"
fi
