-- AlterTable
ALTER TABLE "files" ADD COLUMN "thumbnail_file_id" UUID;

-- AlterTable
ALTER TABLE "users" ADD COLUMN "avatar_file_id" UUID;

-- CreateIndex
CREATE INDEX "files_thumbnail_file_id_idx" ON "files"("thumbnail_file_id");

-- CreateIndex
CREATE UNIQUE INDEX "users_avatar_file_id_key" ON "users"("avatar_file_id");

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_avatar_file_id_fkey" FOREIGN KEY ("avatar_file_id") REFERENCES "files"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "files" ADD CONSTRAINT "files_thumbnail_file_id_fkey" FOREIGN KEY ("thumbnail_file_id") REFERENCES "files"("id") ON DELETE SET NULL ON UPDATE CASCADE;
