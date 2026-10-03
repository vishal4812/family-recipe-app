ALTER TABLE "recipes" ADD COLUMN "collection" VARCHAR(80);

CREATE INDEX "recipes_user_id_collection_idx" ON "recipes"("user_id", "collection");
