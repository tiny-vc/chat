CREATE TABLE "message_read_cursors" (
    "user_id" UUID NOT NULL,
    "channel_id" UUID NOT NULL,
    "channel_type" INTEGER NOT NULL,
    "last_message_seq" BIGINT NOT NULL DEFAULT 0,
    "updated_at" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "message_read_cursors_pkey" PRIMARY KEY ("user_id", "channel_id", "channel_type")
);

CREATE INDEX "message_read_cursors_channel_id_channel_type_last_message_seq_idx"
ON "message_read_cursors"("channel_id", "channel_type", "last_message_seq");

ALTER TABLE "message_read_cursors"
ADD CONSTRAINT "message_read_cursors_user_id_fkey"
FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
