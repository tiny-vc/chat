CREATE TABLE "runtime_settings" (
    "id" INTEGER NOT NULL DEFAULT 1,
    "registration_enabled" BOOLEAN NOT NULL DEFAULT true,
    "messaging_enabled" BOOLEAN NOT NULL DEFAULT true,
    "files_enabled" BOOLEAN NOT NULL DEFAULT true,
    "groups_enabled" BOOLEAN NOT NULL DEFAULT true,
    "audio_calls_enabled" BOOLEAN NOT NULL DEFAULT true,
    "video_calls_enabled" BOOLEAN NOT NULL DEFAULT true,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "runtime_settings_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "runtime_settings_singleton" CHECK ("id" = 1)
);

INSERT INTO "runtime_settings" ("id", "updated_at") VALUES (1, CURRENT_TIMESTAMP);
