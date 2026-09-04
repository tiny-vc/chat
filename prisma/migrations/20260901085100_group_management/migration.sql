-- AlterTable
ALTER TABLE "groups" ADD COLUMN "avatar_file_id" UUID;

-- CreateIndex
CREATE UNIQUE INDEX "groups_avatar_file_id_key" ON "groups"("avatar_file_id");

-- AddForeignKey
ALTER TABLE "groups" ADD CONSTRAINT "groups_avatar_file_id_fkey" FOREIGN KEY ("avatar_file_id") REFERENCES "files"("id") ON DELETE SET NULL ON UPDATE CASCADE;
