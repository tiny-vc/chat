#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
env_file="$project_dir/.env.production"
compose_file=
check_only=false
skip_pull=false
mode_override=
minimum_free_gb=${MINIMUM_FREE_GB:-10}

usage() {
  cat <<'EOF'
Usage: scripts/deploy-production.sh [options]

Options:
  --check-only       Validate without pulling, building, or starting services
  --skip-pull        Start using images already present on the server
  --env-file PATH    Use a different production environment file
  --mode MODE        Deployment mode: standalone or external
  -h, --help         Show this help
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --check-only) check_only=true ;;
    --skip-pull) skip_pull=true ;;
    --env-file)
      [ "$#" -ge 2 ] || { printf '%s\n' 'Missing value for --env-file' >&2; exit 2; }
      env_file=$2
      shift
      ;;
    --mode)
      [ "$#" -ge 2 ] || { printf '%s\n' 'Missing value for --mode' >&2; exit 2; }
      mode_override=$2
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
require_command openssl
require_command curl
[ -f "$env_file" ] || fail "Missing environment file: $env_file"
deployment_mode=${mode_override:-$(env_value DEPLOYMENT_MODE)}
deployment_mode=${deployment_mode:-standalone}
case "$deployment_mode" in
  standalone) compose_file="$project_dir/docker-compose.production.yml" ;;
  external) compose_file="$project_dir/docker-compose.external-services.yml" ;;
  *) fail "DEPLOYMENT_MODE must be standalone or external" ;;
esac
[ -f "$compose_file" ] || fail "Missing Compose file for $deployment_mode mode"
[ -f deploy/nginx/nginx.production.conf ] || fail \
  "Copy deploy/nginx/nginx.production.example.conf to deploy/nginx/nginx.production.conf"
if [ "$deployment_mode" = standalone ]; then
  [ -f deploy/livekit/livekit.production.yaml ] || fail \
    "Copy deploy/livekit/livekit.production.example.yaml to deploy/livekit/livekit.production.yaml"
fi
[ -r deploy/certs/fullchain.pem ] || fail "Missing readable deploy/certs/fullchain.pem"
[ -r deploy/certs/privkey.pem ] || fail "Missing readable deploy/certs/privkey.pem"

docker compose version >/dev/null 2>&1 || fail "Docker Compose plugin is unavailable"
docker info >/dev/null 2>&1 || fail "Docker daemon is unavailable"

step "Checking secrets and public configuration"
if [ "$deployment_mode" = standalone ]; then
  grep -Eiq 'example\.com|replace-with|change-me|local-development-secret' \
    "$env_file" deploy/nginx/nginx.production.conf \
    deploy/livekit/livekit.production.yaml && \
    fail "Production configuration still contains placeholders"
else
  grep -Eiq 'example\.com|replace-with|change-me|local-development-secret' \
    "$env_file" deploy/nginx/nginx.production.conf && \
    fail "Production configuration still contains placeholders"
fi

[ "$(env_value NODE_ENV)" = production ] || fail "NODE_ENV must be production"
[ "$(env_value SWAGGER_ENABLED)" = false ] || fail "SWAGGER_ENABLED must be false"
[ "$(env_value S3_AUTO_CREATE_BUCKET)" = false ] || fail "S3_AUTO_CREATE_BUCKET must be false"

if [ "$deployment_mode" = standalone ]; then
  docker run --rm -i \
    -v "$env_file:/workspace/.env.production:ro" \
    -v "$project_dir/deploy/livekit/livekit.production.yaml:/workspace/livekit.yaml:ro" \
    node:24.20.0-alpine node - /workspace/.env.production /workspace/livekit.yaml <<'NODE'
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
for (const name of ['CHAT_API_IMAGE', 'CHAT_MIGRATE_IMAGE', 'CHAT_ADMIN_IMAGE']) {
  const image = env[name] || '';
  if (!image.includes(':') && !image.includes('@sha256:')) throw new Error(`${name} must include a tag or digest`);
  if (/:(latest|main)$/i.test(image)) throw new Error(`${name} must use an immutable version or commit tag`);
}
NODE
else
  docker run --rm -i \
    -v "$env_file:/workspace/.env.production:ro" \
    node:24.20.0-alpine node - /workspace/.env.production <<'NODE'
const fs = require('node:fs');
const envPath = process.argv[2];
const env = Object.fromEntries(fs.readFileSync(envPath, 'utf8').split(/\r?\n/)
  .filter((line) => line && !line.startsWith('#') && line.includes('='))
  .map((line) => [line.slice(0, line.indexOf('=')), line.slice(line.indexOf('=') + 1)]));
for (const [name, schemes] of Object.entries({
  DATABASE_URL: ['postgresql://', 'postgres://'],
  WUKONGIM_API_URL: ['http://', 'https://'], WUKONGIM_WS_URL: ['wss://'],
  LIVEKIT_HTTP_URL: ['http://', 'https://'], LIVEKIT_URL: ['wss://'],
  S3_ENDPOINT: ['http://', 'https://'], S3_PUBLIC_ENDPOINT: ['https://'],
})) {
  if (!schemes.some((scheme) => env[name]?.startsWith(scheme))) {
    throw new Error(`${name} must use ${schemes.join(' or ')} in external mode`);
  }
}
for (const name of ['CHAT_API_IMAGE', 'CHAT_MIGRATE_IMAGE', 'CHAT_ADMIN_IMAGE']) {
  const image = env[name] || '';
  if (!image.includes(':') && !image.includes('@sha256:')) throw new Error(`${name} must include a tag or digest`);
  if (/:(latest|main)$/i.test(image)) throw new Error(`${name} must use an immutable version or commit tag`);
}
NODE
fi

step "Checking certificates"
openssl x509 -in deploy/certs/fullchain.pem -noout >/dev/null 2>&1 || fail "Invalid TLS certificate"
openssl pkey -in deploy/certs/privkey.pem -noout >/dev/null 2>&1 || fail "Invalid TLS private key"
cert_public=$(openssl x509 -in deploy/certs/fullchain.pem -pubkey -noout | openssl pkey -pubin -outform DER 2>/dev/null | openssl dgst -sha256)
key_public=$(openssl pkey -in deploy/certs/privkey.pem -pubout -outform DER 2>/dev/null | openssl dgst -sha256)
[ "$cert_public" = "$key_public" ] || fail "TLS certificate and private key do not match"
openssl x509 -checkend 604800 -noout -in deploy/certs/fullchain.pem >/dev/null || \
  fail "TLS certificate expires within seven days"
api_domain=$(env_value API_PUBLIC_URL)
api_domain=${api_domain#https://}
im_domain=$(env_value WUKONGIM_WS_URL)
im_domain=${im_domain#wss://}
tls_domains="$api_domain"
if [ "$deployment_mode" = standalone ]; then
  rtc_domain=$(env_value LIVEKIT_URL)
  rtc_domain=${rtc_domain#wss://}
  turn_domain=$(sed -n 's/^[[:space:]]*domain:[[:space:]]*//p' \
    deploy/livekit/livekit.production.yaml | head -n 1)
  tls_domains="$tls_domains $im_domain $rtc_domain $turn_domain"
fi
for domain in $tls_domains; do
  [ -n "$domain" ] || fail "Unable to determine every TLS domain"
  openssl x509 -checkhost "$domain" -noout -in deploy/certs/fullchain.pem >/dev/null || \
    fail "TLS certificate does not cover $domain"
done

step "Checking $deployment_mode deployment and Compose configuration"
if [ "$deployment_mode" = standalone ]; then
  grep -Fq 'WK_WEBHOOK_HTTPADDR: http://api:3000/api/v1/webhooks/wukongim/${WUKONGIM_WEBHOOK_SECRET}' \
    "$compose_file" || fail "WuKongIM msg.notify webhook is not routed to the API"
  grep -Fq 'WK_WEBHOOK_MSGNOTIFYEVENTPUSHINTERVAL: 500ms' "$compose_file" || \
    fail "WuKongIM msg.notify batching interval is not configured"
  docker run --rm \
    -v "$project_dir:/workspace:ro" \
    -w /workspace \
    node:24.20.0-alpine \
    node scripts/verify-livekit-production.mjs
elif grep -Eq 'proxy_pass http://(minio|wukongim|host\.docker\.internal)' deploy/nginx/nginx.production.conf; then
  fail "External mode requires deploy/nginx/nginx.external-services.example.conf"
fi
CHAT_ENV_FILE="$env_file" docker compose --env-file "$env_file" \
  -f "$compose_file" config --quiet

free_kb=$(df -Pk "$project_dir" | awk 'NR == 2 { print $4 }')
case "$free_kb" in *[!0-9]*|'') fail "Unable to determine free disk space" ;; esac
required_kb=$((minimum_free_gb * 1024 * 1024))
[ "$free_kb" -ge "$required_kb" ] || \
  fail "Less than ${minimum_free_gb} GiB is free on the deployment filesystem"

if [ "$(uname -s)" != Linux ]; then
  [ "$check_only" = true ] || fail "Production deployment requires Linux"
  printf '%s\n' 'WARNING: configuration checked on non-Linux; port and host-network behavior remain unverified.'
else
  existing_containers=$(CHAT_ENV_FILE="$env_file" docker compose --env-file "$env_file" \
    -f "$compose_file" ps -q)
  if [ -z "$existing_containers" ]; then
    require_command ss
    ports="80 443"
    [ "$deployment_mode" = external ] || ports="$ports 5100 7880 7881 5349"
    for port in $ports; do
      if ss -H -ltn | awk -v suffix=":$port" '$4 ~ (suffix "$") { found=1 } END { exit !found }'; then
        fail "TCP port $port is already in use"
      fi
    done
    if [ "$deployment_mode" = standalone ] && ss -H -lun | awk -v suffix=":443" '$4 ~ (suffix "$") { found=1 } END { exit !found }'; then
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

if [ "$skip_pull" = false ]; then
  step "Pulling immutable production images"
  CHAT_ENV_FILE="$env_file" docker compose --env-file "$env_file" \
    -f "$compose_file" pull
fi

step "Starting production services"
CHAT_ENV_FILE="$env_file" docker compose --env-file "$env_file" \
  -f "$compose_file" up -d --no-build --remove-orphans --wait

step "Checking service readiness"
public_url=$(env_value API_PUBLIC_URL)
curl --fail --silent --show-error --retry 10 --retry-delay 3 \
  "$public_url/api/v1/health" >/dev/null
curl --fail --silent --show-error --retry 10 --retry-delay 3 \
  "$public_url/api/v1/ready" >/dev/null
CHAT_ENV_FILE="$env_file" docker compose --env-file "$env_file" \
  -f "$compose_file" ps
printf '\nProduction deployment completed successfully: %s\n' "$public_url"
printf '%s\n' 'Optional media webhook check: sh scripts/verify-wukong-media-webhook-production.sh'
