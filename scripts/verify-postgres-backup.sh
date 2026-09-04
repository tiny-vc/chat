#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
  printf 'Usage: %s <backup.dump>\n' "$0" >&2
  exit 2
fi

backup_file=$1
checksum_file="$backup_file.sha256"
project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

test -f "$backup_file"
test -f "$checksum_file"
cd "$(dirname -- "$backup_file")"
shasum -a 256 -c "$(basename -- "$checksum_file")"

cd "$project_dir"
docker compose exec -T postgres pg_restore --list < "$backup_file" > /dev/null
printf 'Backup archive is readable: %s\n' "$backup_file"
