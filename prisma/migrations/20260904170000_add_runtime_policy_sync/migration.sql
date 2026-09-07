CREATE TABLE "runtime_policy_syncs" (
  "key" VARCHAR(80) NOT NULL,
  "desired_enabled" BOOLEAN NOT NULL,
  "status" VARCHAR(20) NOT NULL DEFAULT 'PENDING',
  "attempts" INTEGER NOT NULL DEFAULT 0,
  "next_attempt_at" TIMESTAMP(3),
  "last_error" VARCHAR(1000),
  "synced_at" TIMESTAMP(3),
  "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "runtime_policy_syncs_pkey" PRIMARY KEY ("key"),
  CONSTRAINT "runtime_policy_syncs_status_check"
    CHECK ("status" IN ('PENDING', 'SYNCING', 'SYNCED', 'FAILED'))
);

CREATE INDEX "runtime_policy_syncs_status_next_attempt_at_idx"
  ON "runtime_policy_syncs"("status", "next_attempt_at");

INSERT INTO "runtime_policy_syncs" (
  "key", "desired_enabled", "status", "attempts", "synced_at", "updated_at"
)
SELECT
  'wukongim.messaging', "messaging_enabled", 'SYNCED', 0,
  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "runtime_settings"
WHERE "id" = 1
ON CONFLICT ("key") DO NOTHING;
