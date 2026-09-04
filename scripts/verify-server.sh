#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$project_dir"

npm run lint
npm test -- --runInBand
npm run build
npm run openapi:generate
docker compose config --quiet

test -s openapi/chat-api.json
test -s clients/dart/chat_api/lib/src/api/admin_api.dart
test -s clients/typescript/admin_api/api/admin-api.ts

node -e '
  const document = require("./openapi/chat-api.json");
  const required = [
    "/api/v1/auth/login",
    "/api/v1/friends",
    "/api/v1/groups",
    "/api/v1/files/uploads",
    "/api/v1/calls",
    "/api/v1/admin/overview",
  ];
  const missing = required.filter((path) => !document.paths[path]);
  if (missing.length) throw new Error(`Missing required API paths: ${missing.join(", ")}`);
  console.log(`Server baseline verified: ${Object.keys(document.paths).length} API paths`);
'
