#!/bin/bash

set -e

DB_NAME="${DB_NAME:-capstone}"
BACKUP_FILE="$1"

if [ -z "$BACKUP_FILE" ]; then
echo "Usage: ./scripts/restore.sh <backup-file>"
exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
echo "Backup file not found: $BACKUP_FILE"
exit 1
fi

echo "Restoring PostgreSQL database..."
echo "Database: $DB_NAME"
echo "Backup: $BACKUP_FILE"

pg_restore
--clean
--if-exists
--dbname="$DB_NAME"
"$BACKUP_FILE"

echo "Restore completed successfully."
