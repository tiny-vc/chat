#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
env_file=${CHAT_ENV_FILE:-$project_dir/.env.production}
compose_file="$project_dir/docker-compose.production.yml"

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

command -v docker >/dev/null 2>&1 || fail 'Docker is required.'
[ -f "$env_file" ] || fail 'Missing .env.production.'
if grep -q '^DEPLOYMENT_MODE=external$' "$env_file"; then
  compose_file="$project_dir/docker-compose.external-services.yml"
fi
[ -f "$compose_file" ] || fail 'Missing selected production Compose file.'

cd "$project_dir"
CHAT_ENV_FILE="$env_file" docker compose --env-file "$env_file" \
  -f "$compose_file" exec -T api \
  node dist/cli/verify-wukong-media-webhook.js
