# syntax=docker/dockerfile:1
FROM node:24.20.0-alpine AS build

WORKDIR /workspace
COPY clients/typescript/admin_api ./clients/typescript/admin_api
COPY apps/admin_web/package.json apps/admin_web/package-lock.json ./apps/admin_web/

WORKDIR /workspace/clients/typescript/admin_api
RUN --mount=type=cache,target=/root/.npm npm install

WORKDIR /workspace/apps/admin_web
RUN --mount=type=cache,target=/root/.npm npm ci

COPY apps/admin_web ./
RUN npm run build

FROM nginx:1.29-alpine AS runtime

COPY apps/admin_web/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /workspace/apps/admin_web/dist /usr/share/nginx/html

EXPOSE 80
HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/healthz || exit 1
