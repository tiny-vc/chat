ALTER TABLE "files" ADD COLUMN "referenced_at" TIMESTAMP(3);

-- Existing READY chat media predates reference tracking and must remain
-- available. New uploads start with NULL until WuKongIM confirms the message.
UPDATE "files"
SET "referenced_at" = COALESCE("uploaded_at", "created_at")
WHERE "status" = 'READY'
  AND "purpose" IN ('CHAT_IMAGE', 'CHAT_VIDEO', 'CHAT_VOICE', 'CHAT_FILE');

CREATE INDEX "files_status_referenced_at_created_at_idx"
ON "files"("status", "referenced_at", "created_at");
