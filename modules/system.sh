#!/usr/bin/env bash
# Systemd units: git-on-shutdown (auto commit/push) and dconf-update-on-shutdown.
# Requires sudo. Opt-in: never called by install.sh.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/helpers.sh"

if [[ "$EUID" -eq 0 ]]; then
  echo "Please run this script as a regular user, not as root."
  exit 1
fi

# Keep the sudo session alive while the script is running.
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

setup_git_updater() {
  echo "INFO: setting up automated commits on shutdown"
  local SCRIPT_PATH=/usr/local/bin/git-on-shutdown.sh
  local SERVICE_PATH=/etc/systemd/system/git-on-shutdown.service
  cat <<EOF | sudo tee ${SCRIPT_PATH} >/dev/null
#!/bin/bash
set -e
cd "${DOTFILES_HOME}"

BRANCH_NAME=\$(hostname)
echo "INFO: checking out branch"
/usr/bin/git checkout "\${BRANCH_NAME}" || /usr/bin/git checkout -b "\${BRANCH_NAME}"

echo "INFO: staging changes"
/usr/bin/git add .

# Only commit if there are actual changes staged.
if ! /usr/bin/git diff-index --quiet HEAD; then
echo "INFO: changes detected, commiting"
/usr/bin/git commit -m "automated: sync dotfiles files for \${BRANCH_NAME}"
fi
echo "INFO: pushing changes"
/usr/bin/git push --force-with-lease --set-upstream origin \${BRANCH_NAME}
EOF

  cat <<EOF | sudo tee ${SERVICE_PATH} >/dev/null
[Unit]
Description=Push dotfiles repository changes.
After=network.target

[Service]
User=$(id -un)
Group=$(id -gn)
Type=oneshot
RemainAfterExit=true
ExecStart=/bin/true
ExecStop=${SCRIPT_PATH}
TimeoutSec=infinity
TimeoutStopSec=20

[Install]
WantedBy=multi-user.target
EOF

  sudo chmod +x ${SCRIPT_PATH}
  sudo systemctl daemon-reload
  sudo systemctl enable "${SERVICE_PATH}"
}

setup_dconf_updater() {
  echo "INFO: updating dconf configuration"
  local SCRIPT_PATH=/usr/local/bin/dconf-update-on-shutdown.sh
  local SERVICE_PATH=/etc/systemd/system/dconf-update-on-shutdown.service
  cat <<EOF | sudo tee ${SCRIPT_PATH} >/dev/null
#!/bin/bash
set -e

echo "INFO: dumping gnome configs"
dconf dump / > ${DOTFILES_HOME}/config/dconf/settings.dump
EOF

  cat <<EOF | sudo tee ${SERVICE_PATH} >/dev/null
[Unit]
Description=Update gnome configurations dump file.
After=git-on-shutdown.service

[Service]
User=$(id -un)
Group=$(id -gn)
Type=oneshot
RemainAfterExit=true
ExecStart=/bin/true
ExecStop=${SCRIPT_PATH}
TimeoutStopSec=20

[Install]
WantedBy=git-on-shutdown.service
EOF

  sudo chmod +x ${SCRIPT_PATH}
  sudo systemctl daemon-reload
  sudo systemctl enable "${SERVICE_PATH}"
}

setup_git_updater
if command -v dconf >/dev/null; then
  setup_dconf_updater
fi

echo "Systemd units installed."
