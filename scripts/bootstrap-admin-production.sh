#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
env_file="$project_dir/.env.production"
compose_file="$project_dir/docker-compose.production.yml"

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

restore_terminal() {
  stty echo 2>/dev/null || true
}
trap restore_terminal EXIT HUP INT TERM

[ -t 0 ] || fail 'Run this script from an interactive server terminal.'
command -v docker >/dev/null 2>&1 || fail 'Docker is required.'
[ -f "$env_file" ] || fail '.env.production is missing.'
[ -f "$compose_file" ] || fail 'docker-compose.production.yml is missing.'
docker compose version >/dev/null 2>&1 || fail 'Docker Compose plugin is unavailable.'

printf 'Administrator username [admin]: '
IFS= read -r username
username=${username:-admin}
printf 'Administrator nickname [Administrator]: '
IFS= read -r nickname
nickname=${nickname:-Administrator}

printf 'Administrator password (12-72 characters): '
stty -echo
IFS= read -r password
stty echo
printf '\nConfirm password: '
stty -echo
IFS= read -r password_confirmation
stty echo
printf '\n'

[ "$password" = "$password_confirmation" ] || fail 'Passwords do not match.'
[ "${#password}" -ge 12 ] && [ "${#password}" -le 72 ] || \
  fail 'Password must be 12-72 characters.'

cd "$project_dir"
printf '%s\n%s\n%s\n' "$username" "$nickname" "$password" | \
  docker compose --env-file "$env_file" -f "$compose_file" \
    run --rm --no-deps -T api node dist/cli/bootstrap-admin.js

password=
password_confirmation=
printf '%s\n' 'Initial administrator bootstrap completed.'
