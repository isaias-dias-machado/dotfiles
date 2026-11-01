#!/usr/bin/env bash
# Loads GNOME settings from the text dump. NOT part of install.sh: loading a
# dump overwrites current GNOME settings. Run explicitly, opt-in.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/helpers.sh"

if [ "$DRY_RUN" = "1" ]; then
  say "DRY: dconf load / < $DOTFILES_HOME/config/dconf/settings.dump"
else
  dconf load / < "$DOTFILES_HOME/config/dconf/settings.dump"
fi
