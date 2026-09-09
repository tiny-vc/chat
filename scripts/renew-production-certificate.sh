#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
env_file="$project_dir/.env.production"
compose_file="$project_dir/docker-compose.production.yml"
certbot_image=certbot/certbot:v5.8.0
renew_before_seconds=${RENEW_BEFORE_SECONDS:-2592000}
gateway_was_running=false

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

restore_gateway() {
  if [ "$gateway_was_running" = true ]; then
    docker compose --env-file "$env_file" -f "$compose_file" start gateway >/dev/null
  fi
}
trap restore_gateway EXIT HUP INT TERM

cd "$project_dir"
[ -f "$env_file" ] || fail '.env.production is missing.'
if grep -q '^DEPLOYMENT_MODE=external$' "$env_file"; then
  compose_file="$project_dir/docker-compose.external-services.yml"
fi
[ -f "$compose_file" ] || fail 'The selected production Compose file is missing.'
[ -f deploy/certs/fullchain.pem ] || fail 'Installed certificate is missing.'
[ -d deploy/letsencrypt/renewal ] || fail 'No Certbot renewal configuration was found.'
case "$renew_before_seconds" in *[!0-9]*|'') fail 'RENEW_BEFORE_SECONDS must be numeric.' ;; esac

if openssl x509 -checkend "$renew_before_seconds" -noout \
  -in deploy/certs/fullchain.pem >/dev/null; then
  printf '%s\n' 'Certificate is not within the renewal window; nothing to do.'
  exit 0
fi

api_url=$(sed -n 's/^API_PUBLIC_URL=//p' "$env_file" | tail -n 1)
cert_name=${api_url#https://}
[ -n "$cert_name" ] || fail 'Unable to determine the Certbot certificate name.'

if [ -n "$(docker compose --env-file "$env_file" -f "$compose_file" ps --status running -q gateway 2>/dev/null)" ]; then
  gateway_was_running=true
  docker compose --env-file "$env_file" -f "$compose_file" stop gateway
fi

docker run --rm -p 80:80 \
  -v "$project_dir/deploy/letsencrypt:/etc/letsencrypt" \
  -v "$project_dir/deploy/letsencrypt-lib:/var/lib/letsencrypt" \
  "$certbot_image" renew --cert-name "$cert_name" --standalone --non-interactive

install -m 644 "deploy/letsencrypt/live/$cert_name/fullchain.pem" \
  deploy/certs/fullchain.pem
install -m 600 "deploy/letsencrypt/live/$cert_name/privkey.pem" \
  deploy/certs/privkey.pem
openssl x509 -checkend 604800 -noout -in deploy/certs/fullchain.pem >/dev/null || \
  fail 'The renewed certificate expires within seven days.'

printf '%s\n' 'Certificate renewal completed successfully.'
