#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
bundle_name=${1:-}
case "$bundle_name" in
  chat-admin-assets-*.tar.gz) ;;
  *) printf '%s\n' 'Usage: scripts/install-admin-assets-production.sh chat-admin-assets-VERSION.tar.gz' >&2; exit 2 ;;
esac

bundle="$project_dir/$bundle_name"
checksum="$bundle.sha256"
[ -f "$bundle" ] || { printf 'Bundle not found: %s\n' "$bundle" >&2; exit 1; }
[ -f "$checksum" ] || { printf 'Checksum not found: %s\n' "$checksum" >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { printf '%s\n' 'Docker is required.' >&2; exit 1; }

(cd "$project_dir" && sha256sum -c "$(basename "$checksum")")
build_dir=$(mktemp -d "${TMPDIR:-/tmp}/chat-admin-install.XXXXXX")
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM
tar -xzf "$bundle" -C "$build_dir"

admin_image=$(sed -n 's/^CHAT_ADMIN_IMAGE=//p' "$build_dir/image.env" | tail -n 1)
case "$admin_image" in
  chat-admin:*[!A-Za-z0-9_.:-]*|chat-admin:|'')
    printf '%s\n' 'Invalid management image tag in bundle.' >&2
    exit 1
    ;;
esac

docker image inspect nginx:1.29-alpine >/dev/null 2>&1 || {
  printf '%s\n' 'Missing nginx:1.29-alpine; run docker pull nginx:1.29-alpine first.' >&2
  exit 1
}
docker build --pull=false --tag "$admin_image" "$build_dir"

healthcheck=$(docker image inspect \
  --format '{{if .Config.Healthcheck}}{{json .Config.Healthcheck.Test}}{{end}}' \
  "$admin_image")
case "$healthcheck" in
  *127.0.0.1/healthz*) ;;
  *)
    printf '%s\n' 'Built management image is missing the required /healthz healthcheck.' >&2
    exit 1
    ;;
esac

env_file="$project_dir/.env.production"
[ -f "$env_file" ] || { printf '%s\n' 'Missing .env.production.' >&2; exit 1; }
grep -q '^CHAT_ADMIN_IMAGE=' "$env_file" || {
  printf '%s\n' 'CHAT_ADMIN_IMAGE is missing from .env.production.' >&2
  exit 1
}
sed -i "s|^CHAT_ADMIN_IMAGE=.*|CHAT_ADMIN_IMAGE=$admin_image|" "$env_file"
sh "$project_dir/scripts/deploy-production.sh" --skip-pull
