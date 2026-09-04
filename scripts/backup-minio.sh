#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
backup_dir=${BACKUP_DIR:-"$project_dir/backups/minio"}
timestamp=$(date -u +%Y%m%dT%H%M%SZ)
final_name="chat-minio-$timestamp"

mkdir -p "$backup_dir"
temporary_dir=$(mktemp -d "$backup_dir/.chat-minio-XXXXXX")
temporary_name=$(basename -- "$temporary_dir")
cleanup() {
  rm -rf "$temporary_dir"
}
trap cleanup EXIT INT TERM

export MINIO_BACKUP_DIR=$backup_dir
export MINIO_BACKUP_NAME=$temporary_name
MINIO_BACKUP_UID=$(id -u)
MINIO_BACKUP_GID=$(id -g)
export MINIO_BACKUP_UID MINIO_BACKUP_GID

cd "$project_dir"
docker compose --profile tools run --rm minio-backup

cd "$temporary_dir"
find objects -type f | LC_ALL=C sort | while IFS= read -r object; do
  shasum -a 256 "$object"
done > manifest.sha256

object_count=$(find objects -type f | wc -l | tr -d ' ')
total_bytes=$(find objects -type f -exec wc -c {} \; | awk '{sum += $1} END {print sum + 0}')
printf 'bucket=chat-files\nobjects=%s\nbytes=%s\ncreated_at=%s\n' \
  "$object_count" "$total_bytes" "$timestamp" > backup.info
chmod -R go-rwx "$temporary_dir"

cd "$backup_dir"
mv "$temporary_name" "$final_name"
trap - EXIT INT TERM

printf 'MinIO backup created: %s/%s (%s objects)\n' "$backup_dir" "$final_name" "$object_count"
