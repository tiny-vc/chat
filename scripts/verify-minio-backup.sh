#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
  printf 'Usage: %s <backup-directory>\n' "$0" >&2
  exit 2
fi

backup_dir=$1
test -d "$backup_dir/objects"
test -f "$backup_dir/manifest.sha256"
test -f "$backup_dir/backup.info"

cd "$backup_dir"
shasum -a 256 -c manifest.sha256
printf 'MinIO backup verified: %s\n' "$backup_dir"
cat backup.info
