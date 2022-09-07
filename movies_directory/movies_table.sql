CREATE TABLE "public"."movies" (
  "id" SERIAL ,
  "title" text,
  "genre" text,
  "release_year" int,
  PRIMARY KEY ("id")
);

INSERT INTO "public"."movies" ("title", "genre", "release_year") VALUES
('Hocus Pocus', 'Horror', 1993),
('Mamma Mia!', 'Romantic', 2008);