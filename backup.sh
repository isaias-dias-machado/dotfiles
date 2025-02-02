#!/bin/bash

# Configuration
KEY="/root/.ssh/backup-key"
SERVER_USER="backup"
SERVER_IP="desktop"
BACKUP_DIR="/var/bak"  # On homelab server
SOURCE_DIR="/"                     # Directory to back up on client
EXCLUDE_FILE="/etc/backup-excludes.txt" # File with exclude patterns (optional)
# Backup name
BACKUP_NAME="${BACKUP_DIR}/latest-bak"
NEW_BACKUP="${BACKUP_DIR}/backup-$(date +%Y-%m-%d-%H%M%S)"


SSH="ssh -i $KEY"

# If purge command is set the backup directory is cleaned
if [[ $1 = "purge" ]]; then
	$SSH ${SERVER_USER}@${SERVER_IP} "rm -rf /var/bak/*"
	shift
fi

RSYNC_OPT="-aAXh"
RSYNC="rsync ${RSYNC_OPT} $@"


# Check SSH connection
if ! $SSH -o ConnectTimeout=10 ${SERVER_USER}@${SERVER_IP} true; then
    echo "$(date): Homelab server unavailable"
    exit 0
fi

# Check if last backup is newer than 7 days
#if $SSH "${SERVER_USER}@${SERVER_IP}" "test -e '${BACKUP_NAME}' && [ \$(stat -c %Y '${BACKUP_NAME}') -lt \$(date -d '1 week ago' +%s) ]"; then
#    echo "$(date): Recent backup exists"
#    exit 0
#fi

# Check if partitions are mounted
for mount in "/home" "/var"; do
  if ! mountpoint -q "$mount"; then
    echo "$(date): $mount not mounted! Aborting."
    exit 1
  fi
done

# Ensure the needed directories exist
$SSH ${SERVER_USER}@${SERVER_IP} <<EOF
	mkdir -p ${BACKUP_NAME}
	mkdir -p ${NEW_BACKUP}
EOF

# Backup data
$RSYNC --delete-after \
    -e "ssh -i /root/.ssh/backup-key" \
    --link-dest="${BACKUP_NAME}" \
    --rsync-path="/usr/bin/rsync" \
    --exclude-from="${EXCLUDE_FILE}" \
    --stats \
    ${SOURCE_DIR} \
    ${SERVER_USER}@${SERVER_IP}:${NEW_BACKUP}

RSYNC_EXIT_CODE=$?
# Allow exit code 24 (partial transfer due to vanished files)
if [ $RSYNC_EXIT_CODE -ne 0 ] && [ $RSYNC_EXIT_CODE -ne 24 ]; then
    echo "$(date): rsync command failed with code $RSYNC_EXIT_CODE! Aborting."
    exit 1
fi

# Atomic swap
$SSH ${SERVER_USER}@${SERVER_IP} <<EOF
  rm -rf "${BACKUP_NAME}.old"
  mv "${BACKUP_NAME}" "${BACKUP_NAME}.old" 2>/dev/null || true
  mv "${NEW_BACKUP}" "${BACKUP_NAME}"
EOF

# Cleanup
$SSH ${SERVER_USER}@${SERVER_IP} "rm -rf ${BACKUP_NAME}.old"

echo "$(date): Updated snapshot on @${SERVER_IP}"
