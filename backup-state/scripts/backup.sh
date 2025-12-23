#!/bin/bash
# State backup script

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR=~/roci/backups
BACKUP_FILE="state-${TIMESTAMP}.tar.gz"

# Create backup directory if needed
mkdir -p "$BACKUP_DIR"

# Create backup
echo "Creating backup: ${BACKUP_FILE}"
tar -czf "${BACKUP_DIR}/${BACKUP_FILE}" -C ~/roci state/

# Show result
echo ""
echo "=== Backup Complete ==="
ls -lh "${BACKUP_DIR}/${BACKUP_FILE}"

echo ""
echo "=== Recent Backups ==="
ls -lht "$BACKUP_DIR" | head -6
