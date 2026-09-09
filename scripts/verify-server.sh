#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$project_dir"

npm run lint
npm test -- --runInBand
npm run build
npm run openapi:generate
docker compose config --quiet
CHAT_ENV_FILE=.env.production.example docker compose \
  --env-file .env.production.example \
  -f docker-compose.production.yml config --quiet
CHAT_ENV_FILE=.env.external-services.example docker compose \
  --env-file .env.external-services.example \
  -f docker-compose.external-services.yml config --quiet

test -s openapi/chat-api.json
test -s clients/dart/chat_api/lib/src/api/admin_api.dart
test -s clients/typescript/admin_api/api/admin-api.ts
test -s dist/cli/bootstrap-admin.js
test -s dist/cli/promote-admin.js
test -s dist/cli/verify-wukong-media-webhook.js
test -s prisma/migrations/20260908120000_add_group_announcement/migration.sql
test -s prisma/migrations/20260908152000_add_file_reference_tracking/migration.sql
test -s prisma/migrations/20260909113000_file_delete_pending/migration.sql
test -s deploy/nginx/nginx.external-services.example.conf

node -e '
  const document = require("./openapi/chat-api.json");
  const required = [
    "/api/v1/auth/login",
    "/api/v1/friends",
    "/api/v1/groups",
    "/api/v1/groups/{groupId}",
    "/api/v1/groups/{groupId}/members/me/nickname",
    "/api/v1/groups/join-requests/pending-count",
    "/api/v1/files/uploads",
    "/api/v1/calls",
    "/api/v1/calls/{callId}/token",
    "/api/v1/admin/overview",
  ];
  const missing = required.filter((path) => !document.paths[path]);
  if (missing.length) throw new Error(`Missing required API paths: ${missing.join(", ")}`);
  const groupUpdate = document.components?.schemas?.UpdateGroupDto?.properties;
  if (!groupUpdate?.announcement) throw new Error("Missing group announcement schema");
  const nickname = document.components?.schemas?.UpdateGroupNicknameDto?.properties;
  if (!nickname?.nickname) throw new Error("Missing group nickname schema");
  const upload = document.components?.schemas?.CreateUploadDto;
  if (!upload?.properties?.sha256 || !upload.required?.includes("sha256")) {
    throw new Error("Missing required upload checksum schema");
  }
  const fileStatuses = document.components?.schemas?.StoredFileResponse?.properties?.status?.enum;
  if (!fileStatuses?.includes("DELETE_PENDING")) {
    throw new Error("Missing durable file deletion status");
  }
  console.log(`Server baseline verified: ${Object.keys(document.paths).length} API paths`);
'
