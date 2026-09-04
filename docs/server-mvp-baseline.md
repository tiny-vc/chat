# Server MVP baseline

This document freezes the first server milestone. New work should preserve these contracts unless an intentional API version change is made.

## Included

- Registration, login, rotating refresh tokens, password changes and multi-device sessions
- User profiles, search, avatars, friends and blocking
- Direct and group messaging through WuKongIM
- Group creation, membership, roles, ownership transfer, mute and join approval
- Versioned text, image, voice, video, file, sticker, call and system message envelopes
- Presigned S3-compatible upload/download, file verification, thumbnails and quotas
- One-to-one audio/video call lifecycle and LiveKit tokens
- Conversation pin, mute and archive settings
- Administrator overview, user/group queries, suspension, device revocation, audit logs and jobs
- PostgreSQL, MinIO and offline WuKongIM backup procedures
- Health/readiness, structured errors, request IDs, OpenAPI and generated clients

## Deferred

- APNs, FCM and vendor offline push
- Message recall
- Group audio/video conferences
- Typing presence, online presence and detailed group read receipts
- Reports, content moderation and full-text message search
- SMS/email verification and account recovery
- Prometheus, multi-node high availability and automated remote backup scheduling
- React management UI and Flutter product UI

## Contract

- REST prefix: `/api/v1`
- OpenAPI version: `1.0.0`
- Message envelope version: see `docs/message-protocol.md`
- Normal messages travel between the client and WuKongIM; the business API does not proxy message bodies.
- Media bytes travel directly to object storage using presigned URLs.
- `S3_ENDPOINT` is internal; `S3_PUBLIC_ENDPOINT` must be reachable by the client.
- Protected requests use the business access token. WuKongIM and LiveKit credentials are separate, scoped credentials returned by the API.

## Verification

Static and contract verification:

```bash
npm run verify:server
```

With the Compose stack running and the documented smoke accounts present:

```bash
npm run smoke
npm run smoke:settings
npm run smoke:media
npm run smoke:groups
npm run smoke:group-joins
npm run smoke:security
npm run smoke:auth
npm run smoke:admin
```

All services must finish with `/api/v1/ready` reporting `status: ok`.

## Production boundary

The bundled Compose configuration is a development topology. Production still requires TLS, private management ports, public TURN/ICE configuration, protected secrets, remote backups, restore drills and deployment-specific monitoring.
