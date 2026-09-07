CREATE TYPE "UserReportStatus" AS ENUM ('PENDING', 'RESOLVED', 'DISMISSED');

CREATE TABLE "user_reports" (
    "id" UUID NOT NULL,
    "reporter_user_id" UUID NOT NULL,
    "target_user_id" UUID NOT NULL,
    "reason" VARCHAR(80) NOT NULL,
    "details" VARCHAR(1000),
    "status" "UserReportStatus" NOT NULL DEFAULT 'PENDING',
    "decided_by_id" UUID,
    "decision_note" VARCHAR(500),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "decided_at" TIMESTAMP(3),
    CONSTRAINT "user_reports_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "user_reports_status_created_at_idx" ON "user_reports"("status", "created_at");
CREATE INDEX "user_reports_target_user_id_status_created_at_idx" ON "user_reports"("target_user_id", "status", "created_at");
CREATE INDEX "user_reports_reporter_user_id_created_at_idx" ON "user_reports"("reporter_user_id", "created_at");

ALTER TABLE "user_reports" ADD CONSTRAINT "user_reports_reporter_user_id_fkey" FOREIGN KEY ("reporter_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "user_reports" ADD CONSTRAINT "user_reports_target_user_id_fkey" FOREIGN KEY ("target_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "user_reports" ADD CONSTRAINT "user_reports_decided_by_id_fkey" FOREIGN KEY ("decided_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
