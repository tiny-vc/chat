CREATE TYPE "GroupJoinRequestType" AS ENUM ('APPLY', 'INVITE');
CREATE TYPE "GroupJoinRequestStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED', 'EXPIRED');

CREATE TABLE "group_join_requests" (
    "id" UUID NOT NULL,
    "group_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "requested_by_id" UUID NOT NULL,
    "decided_by_id" UUID,
    "type" "GroupJoinRequestType" NOT NULL,
    "status" "GroupJoinRequestStatus" NOT NULL DEFAULT 'PENDING',
    "active_key" VARCHAR(100),
    "message" VARCHAR(500),
    "decision_note" VARCHAR(500),
    "expires_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "decided_at" TIMESTAMP(3),
    CONSTRAINT "group_join_requests_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "group_join_requests_active_key_key" ON "group_join_requests"("active_key");
CREATE INDEX "group_join_requests_group_id_status_created_at_idx" ON "group_join_requests"("group_id", "status", "created_at");
CREATE INDEX "group_join_requests_user_id_status_created_at_idx" ON "group_join_requests"("user_id", "status", "created_at");
CREATE INDEX "group_join_requests_expires_at_status_idx" ON "group_join_requests"("expires_at", "status");

ALTER TABLE "group_join_requests" ADD CONSTRAINT "group_join_requests_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "groups"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "group_join_requests" ADD CONSTRAINT "group_join_requests_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "group_join_requests" ADD CONSTRAINT "group_join_requests_requested_by_id_fkey" FOREIGN KEY ("requested_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "group_join_requests" ADD CONSTRAINT "group_join_requests_decided_by_id_fkey" FOREIGN KEY ("decided_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
