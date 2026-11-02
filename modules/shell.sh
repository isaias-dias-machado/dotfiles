#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/helpers.sh"

# Parse arguments
APPEND=0
for arg in "$@"; do
  case "$arg" in
    --append) APPEND=1 ;;
    *)
      printf 'ERROR: unknown argument: %s\n' "$arg" >&2
      printf 'Usage: %s [--append]\n' "$(basename "$0")" >&2
      exit 2
      ;;
  esac
done

# Always link the bashrc.d directory (additive, safe)
link_file "$DOTFILES_HOME/home/bashrc.d" "$HOME/.bashrc.d"
link_file "$DOTFILES_HOME/home/.bashrc.local" "$HOME/.bashrc.local"

# Link the main bashrc loader (unless in append mode)
if [ "$APPEND" -eq 0 ]; then
  link_file "$DOTFILES_HOME/home/.bashrc" "$HOME/.bashrc"
else
  # Append mode: add a marked block to the existing ~/.bashrc
  bashrc_file="$HOME/.bashrc"
  marker_start="# >>> dotfiles bashrc.d (managed by ~/dotfiles) >>>"
  
  # If the file already contains the marker, it's already been appended
  if [ -f "$bashrc_file" ] && grep -q "$marker_start" "$bashrc_file" 2>/dev/null; then
    say "ok   $bashrc_file (already appended)"
    exit 0
  fi
  
  # If the file exists, back it up (cp, not mv — keep the original in place)
  if [ -f "$bashrc_file" ]; then
    rel="${bashrc_file#"$HOME"/}"
    saved="$BACKUP_DIR/$rel"
    say "bak  $bashrc_file -> $saved"
    run mkdir -p "$(dirname "$saved")"
    run cp -a "$bashrc_file" "$saved"
  fi
  
  # Append the marked block
  say "append $bashrc_file"
  run mkdir -p "$(dirname "$bashrc_file")"
  cat >> "$bashrc_file" <<'EOF'

# >>> dotfiles bashrc.d (managed by ~/dotfiles) >>>
if [ -d "$HOME/.bashrc.d" ]; then
  case $- in *i*) ;; *) : ;; esac  # no-op for non-interactive shells
  for f in "$HOME/.bashrc.d"/*.sh; do [ -r "$f" ] && . "$f"; done
fi
# <<< dotfiles bashrc.d <<<
EOF
fi
