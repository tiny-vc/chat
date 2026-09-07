ALTER TABLE "call_sessions"
ADD COLUMN "initiator_session_id" UUID,
ADD COLUMN "target_session_id" UUID;

CREATE INDEX "call_sessions_initiator_session_id_idx"
ON "call_sessions"("initiator_session_id");

CREATE INDEX "call_sessions_target_session_id_idx"
ON "call_sessions"("target_session_id");
