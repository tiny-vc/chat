#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
env_file="$project_dir/.env.production"
compose_file="$project_dir/docker-compose.production.yml"
check_only=false
skip_build=false
minimum_free_gb=${MINIMUM_FREE_GB:-10}

usage() {
  cat <<'EOF'
Usage: scripts/deploy-production.sh [options]

Options:
  --check-only       Validate without pulling, building, or starting services
  --no-build         Start using existing application images
  --env-file PATH    Use a different production environment file
  -h, --help         Show this help
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --check-only) check_only=true ;;
    --no-build) skip_build=true ;;
    --env-file)
      [ "$#" -ge 2 ] || { printf '%s\n' 'Missing value for --env-file' >&2; exit 2; }
      env_file=$2
      shift
      ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

case "$env_file" in
  /*) ;;
  *) env_file="$project_dir/$env_file" ;;
esac

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

step() {
  printf '\n==> %s\n' "$1"
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

env_value() {
  key=$1
  sed -n "s/^${key}=//p" "$env_file" | tail -n 1
}

cd "$project_dir"
require_command docker
require_command node
require_command npm
require_command openssl
require_command curl
[ -f "$compose_file" ] || fail "Missing docker-compose.production.yml"
[ -f "$env_file" ] || fail "Missing environment file: $env_file"
[ -f deploy/nginx/nginx.production.conf ] || fail \
  "Copy deploy/nginx/nginx.production.example.conf to deploy/nginx/nginx.production.conf"
[ -f deploy/livekit/livekit.production.yaml ] || fail \
  "Copy deploy/livekit/livekit.production.example.yaml to deploy/livekit/livekit.production.yaml"
[ -r deploy/certs/fullchain.pem ] || fail "Missing readable deploy/certs/fullchain.pem"
[ -r deploy/certs/privkey.pem ] || fail "Missing readable deploy/certs/privkey.pem"

docker compose version >/dev/null 2>&1 || fail "Docker Compose plugin is unavailable"
docker info >/dev/null 2>&1 || fail "Docker daemon is unavailable"

step "Checking secrets and public configuration"
if grep -Eiq 'example\.com|replace-with|change-me|local-development-secret' \
  "$env_file" deploy/nginx/nginx.production.conf deploy/livekit/livekit.production.yaml; then
  fail "Production configuration still contains placeholders"
fi

[ "$(env_value NODE_ENV)" = production ] || fail "NODE_ENV must be production"
[ "$(env_value SWAGGER_ENABLED)" = false ] || fail "SWAGGER_ENABLED must be false"
[ "$(env_value S3_AUTO_CREATE_BUCKET)" = false ] || fail "S3_AUTO_CREATE_BUCKET must be false"

node - "$env_file" deploy/livekit/livekit.production.yaml <<'NODE'
const fs = require('node:fs');
const [envPath, livekitPath] = process.argv.slice(2);
const env = Object.fromEntries(fs.readFileSync(envPath, 'utf8').split(/\r?\n/)
  .filter((line) => line && !line.startsWith('#') && line.includes('='))
  .map((line) => [line.slice(0, line.indexOf('=')), line.slice(line.indexOf('=') + 1)]));
const livekit = fs.readFileSync(livekitPath, 'utf8');
const configured = livekit.match(/^keys:\s*\n\s+([^:\s]+):\s*(\S+)/m);
if (!configured || configured[1] !== env.LIVEKIT_API_KEY || configured[2] !== env.LIVEKIT_API_SECRET) {
  throw new Error('LiveKit keys do not match .env.production');
}
for (const [name, scheme] of [
  ['API_PUBLIC_URL', 'https://'], ['WUKONGIM_WS_URL', 'wss://'],
  ['LIVEKIT_URL', 'wss://'], ['S3_PUBLIC_ENDPOINT', 'https://'],
]) {
  if (!env[name]?.startsWith(scheme)) throw new Error(`${name} must start with ${scheme}`);
}
NODE

step "Checking certificates"
openssl x509 -in deploy/certs/fullchain.pem -noout >/dev/null 2>&1 || fail "Invalid TLS certificate"
openssl pkey -in deploy/certs/privkey.pem -noout >/dev/null 2>&1 || fail "Invalid TLS private key"
cert_public=$(openssl x509 -in deploy/certs/fullchain.pem -pubkey -noout | openssl pkey -pubin -outform DER 2>/dev/null | openssl dgst -sha256)
key_public=$(openssl pkey -in deploy/certs/privkey.pem -pubout -outform DER 2>/dev/null | openssl dgst -sha256)
[ "$cert_public" = "$key_public" ] || fail "TLS certificate and private key do not match"
openssl x509 -checkend 604800 -noout -in deploy/certs/fullchain.pem >/dev/null || \
  fail "TLS certificate expires within seven days"

step "Checking LiveKit and Compose configuration"
npm run verify:livekit-production
CHAT_ENV_FILE="$env_file" docker compose --env-file "$env_file" \
  -f "$compose_file" config --quiet

free_kb=$(df -Pk "$project_dir" | awk 'NR == 2 { print $4 }')
case "$free_kb" in *[!0-9]*|'') fail "Unable to determine free disk space" ;; esac
required_kb=$((minimum_free_gb * 1024 * 1024))
[ "$free_kb" -ge "$required_kb" ] || \
  fail "Less than ${minimum_free_gb} GiB is free on the deployment filesystem"

if [ "$(uname -s)" != Linux ]; then
  [ "$check_only" = true ] || fail "Production deployment requires Linux because LiveKit uses host networking"
  printf '%s\n' 'WARNING: configuration checked on non-Linux; port and host-network behavior remain unverified.'
else
  existing_containers=$(CHAT_ENV_FILE="$env_file" docker compose --env-file "$env_file" \
    -f "$compose_file" ps -q)
  if [ -z "$existing_containers" ]; then
    require_command ss
    for port in 80 443 5100 7880 7881 5349; do
      if ss -H -ltn | awk -v suffix=":$port" '$4 ~ (suffix "$") { found=1 } END { exit !found }'; then
        fail "TCP port $port is already in use"
      fi
    done
    if ss -H -lun | awk -v suffix=":443" '$4 ~ (suffix "$") { found=1 } END { exit !found }'; then
      fail "UDP port 443 is already in use"
    fi
  else
    printf '%s\n' 'Existing project containers detected; host port ownership will be preserved during the update.'
  fi
fi

if [ "$check_only" = true ]; then
  printf '\nProduction preflight passed; no services were changed.\n'
  exit 0
fi

step "Building and starting production services"
if [ "$skip_build" = true ]; then
  CHAT_ENV_FILE="$env_file" docker compose --env-file "$env_file" \
    -f "$compose_file" up -d --remove-orphans --wait
else
  CHAT_ENV_FILE="$env_file" docker compose --env-file "$env_file" \
    -f "$compose_file" up -d --build --remove-orphans --wait
fi

step "Checking service readiness"
public_url=$(env_value API_PUBLIC_URL)
curl --fail --silent --show-error --retry 10 --retry-delay 3 \
  "$public_url/api/v1/health" >/dev/null
curl --fail --silent --show-error --retry 10 --retry-delay 3 \
  "$public_url/api/v1/ready" >/dev/null
CHAT_ENV_FILE="$env_file" docker compose --env-file "$env_file" \
  -f "$compose_file" ps
printf '\nProduction deployment completed successfully: %s\n' "$public_url"
