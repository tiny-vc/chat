-- CreateEnum
CREATE TYPE "FileScope" AS ENUM ('PRIVATE', 'DIRECT', 'GROUP');

-- AlterTable
ALTER TABLE "files" ADD COLUMN "scope" "FileScope" NOT NULL DEFAULT 'PRIVATE',
ADD COLUMN "scope_id" UUID;

-- AlterTable
ALTER TABLE "friendships" ADD COLUMN "pair_key" VARCHAR(73) NOT NULL;

-- CreateIndex
CREATE INDEX "files_scope_scope_id_idx" ON "files"("scope", "scope_id");

-- CreateIndex
CREATE UNIQUE INDEX "friendships_pair_key_key" ON "friendships"("pair_key");
