#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
backup_dir=${BACKUP_DIR:-"$project_dir/backups/wukongim"}
timestamp=$(date -u +%Y%m%dT%H%M%SZ)
final_file="$backup_dir/chat-wukongim-$timestamp.tar.gz"
temporary_file=
wukongim_stopped=false

wait_for_wukongim() {
  attempts=0
  while [ "$attempts" -lt 60 ]; do
    container_id=$(docker compose ps -q wukongim)
    if [ -n "$container_id" ]; then
      status=$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' "$container_id")
      if [ "$status" = healthy ]; then
        return 0
      fi
    fi
    attempts=$((attempts + 1))
    sleep 2
  done
  printf 'WuKongIM did not become healthy after restart.\n' >&2
  return 1
}

restart_wukongim() {
  if [ "$wukongim_stopped" = true ]; then
    printf 'Restarting WuKongIM...\n'
    docker compose start wukongim
    wait_for_wukongim
    wukongim_stopped=false
  fi
}

cleanup() {
  exit_status=$?
  if [ -n "$temporary_file" ]; then
    rm -f "$temporary_file"
  fi
  if [ "$wukongim_stopped" = true ]; then
    restart_wukongim || exit_status=1
  fi
  exit "$exit_status"
}
trap cleanup EXIT INT TERM

mkdir -p "$backup_dir"
temporary_file=$(mktemp "$backup_dir/.chat-wukongim-XXXXXX.tar.gz")

cd "$project_dir"
container_id=$(docker compose ps -q wukongim)
if [ -z "$container_id" ]; then
  printf 'WuKongIM container is not running. Start it before creating a backup.\n' >&2
  exit 1
fi

volume_name=$(docker inspect --format '{{range .Mounts}}{{if eq .Destination "/home/wukongimdata"}}{{.Name}}{{end}}{{end}}' "$container_id")
if [ -z "$volume_name" ]; then
  printf 'No named volume is mounted at /home/wukongimdata; refusing to back up an unknown path.\n' >&2
  exit 1
fi

printf 'Stopping WuKongIM for a consistent snapshot...\n'
docker compose stop -t 30 wukongim
wukongim_stopped=true

docker run --rm --volume "$volume_name:/source:ro" alpine:3.22 \
  tar -czf - -C /source . > "$temporary_file"
test -s "$temporary_file"

restart_wukongim
tar -tzf "$temporary_file" > /dev/null

chmod 600 "$temporary_file"
mv "$temporary_file" "$final_file"
temporary_file=

shasum -a 256 "$final_file" > "$final_file.sha256"
entry_count=$(tar -tzf "$final_file" | wc -l | tr -d ' ')
size=$(wc -c < "$final_file" | tr -d ' ')
printf 'volume=%s\nentries=%s\nbytes=%s\ncreated_at=%s\n' \
  "$volume_name" "$entry_count" "$size" "$timestamp" > "$final_file.info"
chmod 600 "$final_file.sha256" "$final_file.info"

trap - EXIT INT TERM
printf 'WuKongIM backup created: %s (%s entries, %s bytes)\n' "$final_file" "$entry_count" "$size"
printf 'WuKongIM is healthy after restart.\n'
