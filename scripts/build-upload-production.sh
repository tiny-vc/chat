#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
ssh_port=${SSH_PORT:-22}
output_dir=${OUTPUT_DIR:-$project_dir/production-bundles}

usage() {
  cat <<'EOF'
Usage: scripts/build-upload-production.sh USER@HOST [REMOTE_DIR] [VERSION]

Build the three application images for linux/amd64, save them in one compressed
archive, upload the deployment-only files, then upload the archive and image
manifest. The server never receives application source code.

Arguments:
  USER@HOST   SSH destination, for example root@203.0.113.10
  REMOTE_DIR  Absolute server directory (default: /opt/chat)
  VERSION     Docker tag (default: sha-<current full Git commit>)

Environment:
  SSH_PORT    SSH port (default: 22)
  OUTPUT_DIR  Local bundle directory (default: ./production-bundles)
  ALLOW_DIRTY Set to true to package uncommitted source changes
EOF
}

[ "$#" -ge 1 ] && [ "$#" -le 3 ] || { usage >&2; exit 2; }
destination=$1
remote_dir=${2:-/opt/chat}

command -v docker >/dev/null 2>&1 || {
  printf '%s\n' 'Docker is required.' >&2
  exit 1
}
docker buildx version >/dev/null 2>&1 || {
  printf '%s\n' 'Docker Buildx is required.' >&2
  exit 1
}

if git -C "$project_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  commit=$(git -C "$project_dir" rev-parse HEAD)
  if [ "${ALLOW_DIRTY:-false}" != true ] && \
    [ -n "$(git -C "$project_dir" status --porcelain)" ]; then
    printf '%s\n' 'Refusing to package uncommitted tracked changes.' >&2
    printf '%s\n' 'Commit them first, or explicitly set ALLOW_DIRTY=true.' >&2
    exit 1
  fi
else
  printf '%s\n' 'The project directory must be a Git working tree.' >&2
  exit 1
fi

version=${3:-sha-$commit}
case "$version" in
  *[!A-Za-z0-9_.-]*|'')
    printf '%s\n' 'VERSION may contain only letters, numbers, dot, underscore and dash.' >&2
    exit 2
    ;;
esac

api_image="chat-api:$version"
migrate_image="chat-migrate:$version"
admin_image="chat-admin:$version"

printf '%s\n' 'Building linux/amd64 production images...'
docker buildx build --platform linux/amd64 --target runtime \
  --tag "$api_image" --load "$project_dir"
docker buildx build --platform linux/amd64 --target migration \
  --tag "$migrate_image" --load "$project_dir"
docker buildx build --platform linux/amd64 --target runtime \
  --tag "$admin_image" --load --file "$project_dir/apps/admin_web/Dockerfile" \
  "$project_dir"

mkdir -p "$output_dir"
bundle_name="chat-production-images-$version-amd64.tar.gz"
bundle="$output_dir/$bundle_name"
manifest="$output_dir/production-images-$version.env"
checksum="$bundle.sha256"
temporary_tar="$output_dir/.chat-production-images-$version-amd64.tar"
trap 'rm -f "$temporary_tar"' EXIT HUP INT TERM

printf '%s\n' 'Saving and compressing production images...'
docker save --output "$temporary_tar" \
  "$api_image" "$migrate_image" "$admin_image"
gzip -9 -c "$temporary_tar" > "$bundle"
rm -f "$temporary_tar"

{
  printf 'CHAT_API_IMAGE=%s\n' "$api_image"
  printf 'CHAT_MIGRATE_IMAGE=%s\n' "$migrate_image"
  printf 'CHAT_ADMIN_IMAGE=%s\n' "$admin_image"
} > "$manifest"

if command -v shasum >/dev/null 2>&1; then
  (cd "$output_dir" && shasum -a 256 "$bundle_name" > "$bundle_name.sha256")
else
  (cd "$output_dir" && sha256sum "$bundle_name" > "$bundle_name.sha256")
fi

SSH_PORT=$ssh_port sh "$project_dir/scripts/upload-production-files.sh" \
  "$destination" "$remote_dir"
scp -P "$ssh_port" "$bundle" "$manifest" "$checksum" \
  "$destination:$remote_dir/"

cat <<EOF

Build and upload complete.

Local bundle:
  $bundle

On the server:
  cd $remote_dir
  sha256sum -c $bundle_name.sha256
  gzip -dc $bundle_name | docker load

Copy the three CHAT_*_IMAGE values from:
  $remote_dir/$(basename "$manifest")
into:
  $remote_dir/.env.production
EOF
