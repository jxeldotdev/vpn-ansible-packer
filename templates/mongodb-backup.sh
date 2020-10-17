#!/usr/bin/env bash

BACKUP_DIR="/var/mongo-backups/"
BACKUP_NAME="pritunl-$(date +%F)"

if ! mongodump; 
if ! test -d "$BACKUP_DIR"; then mkdir -p "$BACKUP_DIR"; fi

mongodump --uri "$URI" --gzip --out "$BACKUP_PATH"

# Upload to Persistent storage e.g GCS / S3
gcloud cp 
# Verify it is uploaded

# Delete old backup

