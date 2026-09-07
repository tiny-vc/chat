# syntax=docker/dockerfile:1
FROM node:24.20.0-alpine AS dependencies
WORKDIR /app
COPY package*.json ./
COPY prisma ./prisma
RUN --mount=type=cache,target=/root/.npm \
    npm ci --fetch-retries=5 --fetch-retry-mintimeout=2000 --fetch-retry-maxtimeout=30000
RUN npx prisma generate

FROM dependencies AS build
COPY nest-cli.json tsconfig*.json ./
COPY src ./src
RUN npm run build

FROM node:24.20.0-alpine AS migration
WORKDIR /app
ENV NODE_ENV=production
COPY deploy/migration/package*.json ./
RUN --mount=type=cache,target=/root/.npm npm ci --omit=dev
COPY prisma ./prisma
CMD ["./node_modules/.bin/prisma", "migrate", "deploy"]

FROM build AS production-deps
RUN npm prune --omit=dev

FROM node:24.20.0-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
COPY --from=production-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
USER node
EXPOSE 3000
CMD ["node", "dist/main.js"]
