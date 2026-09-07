#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
env_file="$project_dir/.env.production"
compose_file="$project_dir/docker-compose.production.yml"
certbot_image=certbot/certbot:v5.8.0

say() {
  printf '\n==> %s\n' "$1"
}

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

ask() {
  prompt=$1
  default=${2:-}
  if [ -n "$default" ]; then
    printf '%s [%s]: ' "$prompt" "$default" >&2
  else
    printf '%s: ' "$prompt" >&2
  fi
  IFS= read -r answer
  printf '%s' "${answer:-$default}"
}

confirm() {
  printf '%s [y/N]: ' "$1" >&2
  IFS= read -r answer
  case "$answer" in y|Y|yes|YES) return 0 ;; *) return 1 ;; esac
}

replace_env() {
  key=$1
  value=$2
  temporary="$env_file.tmp.$$"
  awk -v key="$key" -v value="$value" '
    BEGIN { replaced = 0 }
    index($0, key "=") == 1 { print key "=" value; replaced = 1; next }
    { print }
    END { if (!replaced) print key "=" value }
  ' "$env_file" > "$temporary"
  mv "$temporary" "$env_file"
}

env_value() {
  key=$1
  sed -n "s/^${key}=//p" "$env_file" | tail -n 1
}

valid_domain() {
  case "$1" in
    ''|*[!A-Za-z0-9.-]*|.*|*..*|*.) return 1 ;;
    *) return 0 ;;
  esac
}

cd "$project_dir"
[ "$(uname -s)" = Linux ] || fail 'This setup script must run on the Linux server.'
for command_name in docker openssl gzip sha256sum awk sed; do
  command -v "$command_name" >/dev/null 2>&1 || fail "Required command not found: $command_name"
done
docker compose version >/dev/null 2>&1 || fail 'Docker Compose plugin is unavailable.'
docker info >/dev/null 2>&1 || fail 'Docker daemon is unavailable.'
[ -f "$compose_file" ] || fail 'docker-compose.production.yml is missing.'

say 'Selecting the uploaded application image bundle'
image_manifest=$(ls -1t production-images-*.env 2>/dev/null | head -n 1 || true)
[ -n "$image_manifest" ] || fail 'No production-images-*.env manifest was found in this directory.'
image_manifest=$(ask 'Image manifest' "$image_manifest")
[ -f "$image_manifest" ] || fail "Image manifest not found: $image_manifest"
manifest_name=${image_manifest##*/}
case "$manifest_name" in
  production-images-*.env) ;;
  *) fail 'Image manifest name must match production-images-*.env.' ;;
esac
version=${manifest_name#production-images-}
version=${version%.env}
bundle="chat-production-images-$version-amd64.tar.gz"
[ -f "$bundle" ] || fail "Image bundle not found: $bundle"
[ -f "$bundle.sha256" ] || fail "Checksum file not found: $bundle.sha256"

sha256sum -c "$bundle.sha256"
if confirm 'Import the three application images now?'; then
  gzip -dc "$bundle" | docker load
fi

configure=true
if [ -f "$env_file" ]; then
  if confirm '.env.production already exists. Recreate production configuration and secrets?'; then
    backup_suffix=$(date +%Y%m%d%H%M%S)
    cp "$env_file" "$env_file.backup-$backup_suffix"
  else
    configure=false
  fi
fi

if [ "$configure" = true ]; then
  say 'Creating production configuration'
  [ -f .env.production.example ] || fail '.env.production.example is missing.'
  [ -f deploy/nginx/nginx.production.example.conf ] || fail 'Nginx template is missing.'
  [ -f deploy/livekit/livekit.production.example.yaml ] || fail 'LiveKit template is missing.'

  root_domain=$(ask 'Root domain, for example example.com')
  valid_domain "$root_domain" || fail 'Invalid root domain.'
  chat_domain=$(ask 'Business API and admin domain' "chat.$root_domain")
  im_domain=$(ask 'WuKongIM domain' "im.$root_domain")
  rtc_domain=$(ask 'LiveKit signaling domain' "rtc.$root_domain")
  turn_domain=$(ask 'TURN domain' "turn.$root_domain")
  for domain in "$chat_domain" "$im_domain" "$rtc_domain" "$turn_domain"; do
    valid_domain "$domain" || fail "Invalid domain: $domain"
  done
  server_name=$(ask 'Product/server name' 'Chat')
  [ -n "$server_name" ] || fail 'Server name cannot be empty.'
  case "$server_name" in *'\n'*|*'\r'*) fail 'Server name cannot contain a newline.' ;; esac

  cp .env.production.example "$env_file"
  cp deploy/nginx/nginx.production.example.conf deploy/nginx/nginx.production.conf
  cp deploy/livekit/livekit.production.example.yaml deploy/livekit/livekit.production.yaml

  api_image=$(sed -n 's/^CHAT_API_IMAGE=//p' "$image_manifest")
  migrate_image=$(sed -n 's/^CHAT_MIGRATE_IMAGE=//p' "$image_manifest")
  admin_image=$(sed -n 's/^CHAT_ADMIN_IMAGE=//p' "$image_manifest")
  [ -n "$api_image" ] && [ -n "$migrate_image" ] && [ -n "$admin_image" ] || \
    fail 'The image manifest is incomplete.'

  postgres_password=$(openssl rand -hex 32)
  jwt_secret=$(openssl rand -hex 48)
  manager_token=$(openssl rand -hex 32)
  webhook_secret=$(openssl rand -hex 32)
  livekit_key="API$(openssl rand -hex 12)"
  livekit_secret=$(openssl rand -hex 32)
  s3_access_key="chat$(openssl rand -hex 8)"
  s3_secret_key=$(openssl rand -hex 32)

  replace_env SERVER_NAME "$server_name"
  replace_env CHAT_API_IMAGE "$api_image"
  replace_env CHAT_MIGRATE_IMAGE "$migrate_image"
  replace_env CHAT_ADMIN_IMAGE "$admin_image"
  replace_env POSTGRES_PASSWORD "$postgres_password"
  replace_env DATABASE_URL "postgresql://chat:$postgres_password@postgres:5432/chat?schema=public"
  replace_env JWT_ACCESS_SECRET "$jwt_secret"
  replace_env API_PUBLIC_URL "https://$chat_domain"
  replace_env CORS_ALLOWED_ORIGINS "https://$chat_domain"
  replace_env WUKONGIM_WS_URL "wss://$im_domain"
  replace_env WUKONGIM_TCP_ADDR "$im_domain:5100"
  replace_env WUKONGIM_MANAGER_TOKEN "$manager_token"
  replace_env WUKONGIM_WEBHOOK_SECRET "$webhook_secret"
  replace_env LIVEKIT_URL "wss://$rtc_domain"
  replace_env LIVEKIT_API_KEY "$livekit_key"
  replace_env LIVEKIT_API_SECRET "$livekit_secret"
  replace_env S3_PUBLIC_ENDPOINT "https://$chat_domain"
  replace_env S3_ACCESS_KEY "$s3_access_key"
  replace_env S3_SECRET_KEY "$s3_secret_key"

  sed "s/chat\.example\.com/$chat_domain/g; s/im\.example\.com/$im_domain/g; s/rtc\.example\.com/$rtc_domain/g" \
    deploy/nginx/nginx.production.example.conf > deploy/nginx/nginx.production.conf
  sed "s/chat\.example\.com/$chat_domain/g; s/turn\.example\.com/$turn_domain/g; s/replace-with-livekit-key/$livekit_key/g; s/replace-with-livekit-secret/$livekit_secret/g" \
    deploy/livekit/livekit.production.example.yaml > deploy/livekit/livekit.production.yaml
  chmod 600 "$env_file" deploy/livekit/livekit.production.yaml
  printf '%s\n' 'Production configuration and random secrets were created.'
fi

mkdir -p deploy/certs
if [ ! -s deploy/certs/fullchain.pem ] || [ ! -s deploy/certs/privkey.pem ]; then
  say 'TLS certificate is required'
  cat <<'EOF'
1) Obtain a trusted certificate with the official Certbot container (HTTP-01)
2) Copy an existing fullchain.pem and privkey.pem
3) Configure the certificate later
EOF
  certificate_method=$(ask 'Certificate method' '1')
  case "$certificate_method" in
    1)
      chat_domain=${chat_domain:-$(env_value API_PUBLIC_URL)}
      chat_domain=${chat_domain#https://}
      im_domain=${im_domain:-$(env_value WUKONGIM_WS_URL)}
      im_domain=${im_domain#wss://}
      rtc_domain=${rtc_domain:-$(env_value LIVEKIT_URL)}
      rtc_domain=${rtc_domain#wss://}
      turn_domain=${turn_domain:-$(sed -n 's/^[[:space:]]*domain:[[:space:]]*//p' deploy/livekit/livekit.production.yaml | head -n 1)}
      for domain in "$chat_domain" "$im_domain" "$rtc_domain" "$turn_domain"; do
        valid_domain "$domain" || fail "Cannot obtain a certificate for invalid domain: $domain"
      done
      email=$(ask "Let's Encrypt account email")
      case "$email" in *@*.*) ;; *) fail 'Invalid email address.' ;; esac
      confirm 'Have all four domains been resolved to this server and is TCP port 80 open?' || \
        fail 'Complete DNS and firewall configuration before requesting the certificate.'

      mkdir -p deploy/letsencrypt deploy/letsencrypt-lib
      gateway_was_running=false
      if [ -n "$(docker compose --env-file "$env_file" -f "$compose_file" ps --status running -q gateway 2>/dev/null)" ]; then
        confirm 'The gateway must release port 80 briefly. Stop it now?' || \
          fail 'Certbot standalone mode requires TCP port 80.'
        docker compose --env-file "$env_file" -f "$compose_file" stop gateway
        gateway_was_running=true
      fi

      if docker run --rm -p 80:80 \
        -v "$project_dir/deploy/letsencrypt:/etc/letsencrypt" \
        -v "$project_dir/deploy/letsencrypt-lib:/var/lib/letsencrypt" \
        "$certbot_image" certonly --standalone --preferred-challenges http \
        --non-interactive --agree-tos --no-eff-email --keep-until-expiring \
        --email "$email" --cert-name "$chat_domain" \
        -d "$chat_domain" -d "$im_domain" -d "$rtc_domain" -d "$turn_domain"; then
        install -m 644 "deploy/letsencrypt/live/$chat_domain/fullchain.pem" \
          deploy/certs/fullchain.pem
        install -m 600 "deploy/letsencrypt/live/$chat_domain/privkey.pem" \
          deploy/certs/privkey.pem
      else
        [ "$gateway_was_running" = false ] || \
          docker compose --env-file "$env_file" -f "$compose_file" start gateway
        fail 'Certbot could not obtain the certificate. Check DNS records and TCP port 80.'
      fi
      [ "$gateway_was_running" = false ] || \
        docker compose --env-file "$env_file" -f "$compose_file" start gateway
      ;;
    2)
      cert_source=$(ask 'Existing fullchain.pem path')
      key_source=$(ask 'Existing privkey.pem path')
      [ -r "$cert_source" ] || fail "Certificate is not readable: $cert_source"
      [ -r "$key_source" ] || fail "Private key is not readable: $key_source"
      cp "$cert_source" deploy/certs/fullchain.pem
      cp "$key_source" deploy/certs/privkey.pem
      chmod 644 deploy/certs/fullchain.pem
      chmod 600 deploy/certs/privkey.pem
      ;;
    3)
    cat <<'EOF'

Configuration has been saved. Obtain a trusted certificate covering the chat,
IM, RTC and TURN domains, then place it at:
  /opt/chat/deploy/certs/fullchain.pem
  /opt/chat/deploy/certs/privkey.pem

Run this script again afterward; it will preserve the existing configuration.
EOF
      exit 0
      ;;
    *) fail 'Certificate method must be 1, 2 or 3.' ;;
  esac
fi

say 'Checking the TLS certificate and private key'
openssl x509 -in deploy/certs/fullchain.pem -noout >/dev/null 2>&1 || fail 'Invalid TLS certificate.'
openssl pkey -in deploy/certs/privkey.pem -noout >/dev/null 2>&1 || fail 'Invalid TLS private key.'

if confirm 'Pull the public infrastructure images now?'; then
  docker compose --env-file "$env_file" -f "$compose_file" \
    pull gateway postgres wukongim livekit minio minio-init
fi

say 'Running production preflight checks'
sh scripts/deploy-production.sh --check-only

if confirm 'All checks passed. Start production services now?'; then
  sh scripts/deploy-production.sh --skip-pull
else
  printf '%s\n' 'Configuration is ready. Run scripts/deploy-production.sh --skip-pull when ready.'
fi
