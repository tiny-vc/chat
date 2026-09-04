#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
  printf 'Usage: %s <backup.tar.gz>\n' "$0" >&2
  exit 2
fi

backup_file=$1
checksum_file="$backup_file.sha256"
info_file="$backup_file.info"

test -f "$backup_file"
test -f "$checksum_file"
test -f "$info_file"

cd "$(dirname -- "$backup_file")"
shasum -a 256 -c "$(basename -- "$checksum_file")"
tar -tzf "$(basename -- "$backup_file")" > /dev/null

printf 'WuKongIM backup verified: %s\n' "$backup_file"
cat "$(basename -- "$info_file")"
