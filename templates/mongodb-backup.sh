#!/usr/bin/env bash

set -euo pipefail

MONGO_URI="${1:-mongodb://localhost:27017/pritunl}"
BACKUP_PATH="${2:-/var/mongo-backup/pritunl-$(date +%F)}"
GCS_BUCKET="${3:-gcs://jf-personalcloud-prod-mongo-bkup/}"

# Check dependencies
check_deps() {
  local deps=(gsutil mongodump)

  for dep in $deps; do
    if ! $dep -v; then echo "$dep is not installed, exiting" && exit 1; fi
  done

  if ! test -d "$BACKUP_PATH"; then mkdir -p "$BACKUP_PATH"; fi
}

backup_db() {
  
  if mongodump --uri "$MONGO_URI" --gzip --out "$BACKUP_PATH"; then
    gsutil cp "${BACKUP_PATH}" "${GCS_BUCKET}" && rm -rf "$BACKUP_PATH"
  else
    # check if the backup is actually there, as it could be corrupted
    test -f "${BACKUP_PATH}" && rm -rf "${BACKUP_PATH}"
    echo "Mongodb backup job to ${BACKUP_PATH} failed at $(date +%F-%H:%M)" 1>&2 && exit 1
  fi
}

check_deps
backup_db
