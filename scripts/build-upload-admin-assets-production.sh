#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
ssh_port=${SSH_PORT:-22}
output_dir=${OUTPUT_DIR:-$project_dir/production-bundles}

usage() {
  cat <<'EOF'
Usage: scripts/build-upload-admin-assets-production.sh USER@HOST [REMOTE_DIR] [VERSION]

Build the management web assets locally and upload only the compiled static
files plus the Nginx runtime configuration. No application source is uploaded.
The server assembles the final image using its existing nginx base image.
EOF
}

[ "$#" -ge 1 ] && [ "$#" -le 3 ] || { usage >&2; exit 2; }
destination=$1
remote_dir=${2:-/opt/chat}

case "$destination" in
  *[!A-Za-z0-9_.:@-]*|'') printf '%s\n' 'Invalid USER@HOST value.' >&2; exit 2 ;;
esac
case "$remote_dir" in
  /*) ;;
  *) printf '%s\n' 'REMOTE_DIR must be an absolute path.' >&2; exit 2 ;;
esac
case "$remote_dir" in
  *[!A-Za-z0-9_./-]*) printf '%s\n' 'REMOTE_DIR contains unsupported characters.' >&2; exit 2 ;;
esac
case "$ssh_port" in
  *[!0-9]*|'') printf '%s\n' 'SSH_PORT must be numeric.' >&2; exit 2 ;;
esac

command -v npm >/dev/null 2>&1 || {
  printf '%s\n' 'npm is required for the local production build.' >&2
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
printf 'Building management web assets for %s...\n' "$admin_image"
npm --prefix "$project_dir/apps/admin_web" run build

mkdir -p "$output_dir"
staging_dir=$(mktemp -d "${TMPDIR:-/tmp}/chat-admin-assets.XXXXXX")
trap 'rm -rf "$staging_dir"' EXIT HUP INT TERM
cp -R "$project_dir/apps/admin_web/dist" "$staging_dir/dist"
cp "$project_dir/apps/admin_web/nginx.conf" "$staging_dir/nginx.conf"
cat > "$staging_dir/Dockerfile" <<'DOCKERFILE'
FROM nginx:1.29-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY dist /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/healthz || exit 1
DOCKERFILE
printf 'CHAT_ADMIN_IMAGE=%s\n' "$admin_image" > "$staging_dir/image.env"

bundle_name="chat-admin-assets-$version.tar.gz"
bundle="$output_dir/$bundle_name"
checksum="$bundle.sha256"
tar -C "$staging_dir" -czf "$bundle" Dockerfile nginx.conf dist image.env
if command -v shasum >/dev/null 2>&1; then
  (cd "$output_dir" && shasum -a 256 "$bundle_name" > "$bundle_name.sha256")
else
  (cd "$output_dir" && sha256sum "$bundle_name" > "$bundle_name.sha256")
fi

SSH_PORT=$ssh_port sh "$project_dir/scripts/upload-production-files.sh" \
  "$destination" "$remote_dir"
scp -P "$ssh_port" "$bundle" "$checksum" "$destination:$remote_dir/"

cat <<EOF

Lightweight management bundle uploaded:
  $bundle

On the server, run:
  cd $remote_dir
  sh scripts/install-admin-assets-production.sh $bundle_name
EOF
