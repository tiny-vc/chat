#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
ssh_port=${SSH_PORT:-22}
output_dir=${OUTPUT_DIR:-$project_dir/production-bundles}

usage() {
  cat <<'EOF'
Usage: scripts/build-upload-admin-production.sh USER@HOST [REMOTE_DIR] [VERSION]

Build and upload only the management web image for linux/amd64. Use this for
admin UI-only releases; API and migration images remain unchanged.

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

command -v docker >/dev/null 2>&1 || {
  printf '%s\n' 'Docker is required.' >&2
  exit 1
}
docker buildx version >/dev/null 2>&1 || {
  printf '%s\n' 'Docker Buildx is required.' >&2
  exit 1
}

commit=$(git -C "$project_dir" rev-parse HEAD)
if [ "${ALLOW_DIRTY:-false}" != true ] && \
  [ -n "$(git -C "$project_dir" status --porcelain)" ]; then
  printf '%s\n' 'Refusing to package uncommitted tracked changes.' >&2
  printf '%s\n' 'Commit them first, or explicitly set ALLOW_DIRTY=true.' >&2
  exit 1
fi

version=${3:-sha-$commit}
case "$version" in
  *[!A-Za-z0-9_.-]*|'')
    printf '%s\n' 'VERSION may contain only letters, numbers, dot, underscore and dash.' >&2
    exit 2
    ;;
esac

admin_image="chat-admin:$version"
printf 'Building %s for linux/amd64...\n' "$admin_image"
docker buildx build --platform linux/amd64 --target runtime \
  --tag "$admin_image" --load --file "$project_dir/apps/admin_web/Dockerfile" \
  "$project_dir"

mkdir -p "$output_dir"
bundle_name="chat-admin-$version-amd64.tar.gz"
bundle="$output_dir/$bundle_name"
manifest="$output_dir/admin-image-$version.env"
checksum="$bundle.sha256"
temporary_tar="$output_dir/.chat-admin-$version-amd64.tar"
trap 'rm -f "$temporary_tar"' EXIT HUP INT TERM

printf '%s\n' 'Saving and compressing the management image...'
docker save --output "$temporary_tar" "$admin_image"
gzip -9 -c "$temporary_tar" > "$bundle"
rm -f "$temporary_tar"
printf 'CHAT_ADMIN_IMAGE=%s\n' "$admin_image" > "$manifest"

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

Management image build and upload complete.

On the server:
  cd $remote_dir
  sha256sum -c $bundle_name.sha256
  gzip -dc $bundle_name | docker load
  sed -i 's|^CHAT_ADMIN_IMAGE=.*|CHAT_ADMIN_IMAGE=$admin_image|' .env.production
  sh scripts/deploy-production.sh --skip-pull
EOF
