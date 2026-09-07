#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
ssh_port=${SSH_PORT:-22}

usage() {
  cat <<'EOF'
Usage: scripts/upload-production-files.sh USER@HOST [REMOTE_DIR]

Upload only the files required to deploy production containers. Source code,
Git history, local production secrets and TLS certificates are never uploaded.

Arguments:
  USER@HOST   SSH destination, for example root@203.0.113.10
  REMOTE_DIR  Absolute server directory (default: /opt/chat)

Environment:
  SSH_PORT    SSH port (default: 22)

Example:
  SSH_PORT=22 sh scripts/upload-production-files.sh root@203.0.113.10 /opt/chat
EOF
}

[ "$#" -ge 1 ] && [ "$#" -le 2 ] || { usage >&2; exit 2; }
destination=$1
remote_dir=${2:-/opt/chat}

case "$destination" in
  *[!A-Za-z0-9_.:@-]*|'')
    printf '%s\n' 'Invalid USER@HOST value.' >&2
    exit 2
    ;;
esac
case "$remote_dir" in
  /*) ;;
  *) printf '%s\n' 'REMOTE_DIR must be an absolute path.' >&2; exit 2 ;;
esac
case "$remote_dir" in
  *[!A-Za-z0-9_./-]*)
    printf '%s\n' 'REMOTE_DIR contains unsupported characters.' >&2
    exit 2
    ;;
esac
case "$ssh_port" in
  *[!0-9]*|'') printf '%s\n' 'SSH_PORT must be numeric.' >&2; exit 2 ;;
esac

staging_dir=$(mktemp -d "${TMPDIR:-/tmp}/chat-production-upload.XXXXXX")
trap 'rm -rf "$staging_dir"' EXIT HUP INT TERM

mkdir -p "$staging_dir/scripts" "$staging_dir/deploy/nginx" \
  "$staging_dir/deploy/livekit" "$staging_dir/deploy/certs"

cp "$project_dir/docker-compose.production.yml" "$staging_dir/"
cp "$project_dir/.env.production.example" "$staging_dir/"
cp "$project_dir/deploy/nginx/nginx.production.example.conf" \
  "$staging_dir/deploy/nginx/"
cp "$project_dir/deploy/livekit/livekit.production.example.yaml" \
  "$staging_dir/deploy/livekit/"

for file in \
  deploy-production.sh \
  verify-livekit-production.mjs \
  backup-postgres.sh \
  verify-postgres-backup.sh \
  backup-minio.sh \
  verify-minio-backup.sh \
  backup-wukongim.sh \
  verify-wukongim-backup.sh
do
  cp "$project_dir/scripts/$file" "$staging_dir/scripts/"
done
chmod +x "$staging_dir/scripts/"*.sh

printf 'Uploading production deployment files to %s:%s\n' "$destination" "$remote_dir"
ssh -p "$ssh_port" "$destination" \
  "mkdir -p '$remote_dir/scripts' '$remote_dir/deploy/nginx' '$remote_dir/deploy/livekit' '$remote_dir/deploy/certs'"
scp -P "$ssh_port" \
  "$staging_dir/docker-compose.production.yml" \
  "$staging_dir/.env.production.example" \
  "$destination:$remote_dir/"
scp -P "$ssh_port" "$staging_dir/scripts/"* "$destination:$remote_dir/scripts/"
scp -P "$ssh_port" "$staging_dir/deploy/nginx/nginx.production.example.conf" \
  "$destination:$remote_dir/deploy/nginx/"
scp -P "$ssh_port" "$staging_dir/deploy/livekit/livekit.production.example.yaml" \
  "$destination:$remote_dir/deploy/livekit/"

cat <<EOF

Upload complete. No source code, .git directory, production secrets or TLS
certificates were uploaded.

Next, connect to the server:
  ssh -p $ssh_port $destination
  cd $remote_dir

Create production configuration from the uploaded templates before deploying.
EOF
