#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
backup_dir=${BACKUP_DIR:-"$project_dir/backups/postgres"}
timestamp=$(date -u +%Y%m%dT%H%M%SZ)
final_file="$backup_dir/chat-postgres-$timestamp.dump"

mkdir -p "$backup_dir"
temporary_file=$(mktemp "$backup_dir/.chat-postgres-XXXXXX.dump")
cleanup() {
  rm -f "$temporary_file"
}
trap cleanup EXIT INT TERM

cd "$project_dir"
docker compose exec -T postgres sh -c \
  'pg_dump --username="$POSTGRES_USER" --dbname="$POSTGRES_DB" --format=custom --compress=6 --no-owner --no-acl' \
  > "$temporary_file"

test -s "$temporary_file"
docker compose exec -T postgres pg_restore --list < "$temporary_file" > /dev/null
chmod 600 "$temporary_file"
mv "$temporary_file" "$final_file"
trap - EXIT INT TERM

shasum -a 256 "$final_file" > "$final_file.sha256"
chmod 600 "$final_file.sha256"

size=$(wc -c < "$final_file" | tr -d ' ')
printf 'Backup created: %s (%s bytes)\n' "$final_file" "$size"
printf 'Checksum: %s\n' "$final_file.sha256"
