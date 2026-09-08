#!/bin/bash

set -e

DB_NAME="${DB_NAME:-capstone}"
BACKUP_DIR="${BACKUP_DIR:-backups}"

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/capstone_$(date +%F).dump"

echo "Creating PostgreSQL backup..."
echo "Database: $DB_NAME"
echo "Backup file: $BACKUP_FILE"

pg_dump -Fc -f "$BACKUP_FILE" "$DB_NAME"

echo "Backup completed successfully."

ls -lh "$BACKUP_FILE"
