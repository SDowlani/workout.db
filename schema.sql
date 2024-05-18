-- Tables
CREATE TABLE "people" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT UNIQUE NOT NULL,
    "number" TEXT UNIQUE NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "muscles" (
    "id" INTEGER,
    "name" TEXT UNIQUE NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "equipments" (
    "id" INTEGER,
    "name" TEXT DEFAULT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "levels" (
    "id" INTEGER,
    "type" TEXT UNIQUE NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "exercises" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "muscle_id" INTEGER,
    "equipment_id" INTEGER,
    "level_id" INTEGER,
    FOREIGN KEY("muscle_id") REFERENCES "muscles"("id") ON DELETE CASCADE ,
    FOREIGN KEY("equipment_id") REFERENCES "equipments"("id") ON DELETE SET NULL,
    FOREIGN KEY("level_id") REFERENCES "levels"("id") ON DELETE CASCADE,
    PRIMARY KEY("id")
);

CREATE TABLE "instructions" (
    "exercise_id" INTEGER,
    "info" TEXT NOT NULL,
    FOREIGN KEY("exercise_id") REFERENCES "exercises"("id") ON DELETE CASCADE
);

CREATE TABLE "workouts" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "person_id" INTEGER,
    FOREIGN KEY("person_id") REFERENCES "people"("id") ON DELETE CASCADE,
    PRIMARY KEY("id")
);

CREATE TABLE "assigns" (
    "workout_id" INTEGER,
    "exercise_id" INTEGER,
    "kg" INTEGER CHECK("kg" > 0) DEFAULT NULL,
    "sets" INTEGER CHECK("sets" > 0) DEFAULT 3,
    "reps" INTEGER CHECK("reps" > 0) DEFAULT 10,
    FOREIGN KEY("workout_id") REFERENCES "workouts"("id") ON DELETE CASCADE,
    FOREIGN KEY("exercise_id") REFERENCES "exercises"("id") ON DELETE CASCADE
);


-- Optimizations
    -- Exercise, Instructions and Workout requesting.
CREATE INDEX "exercise_name_search" ON "exercises"("name");
CREATE INDEX "instructions_information_search" ON "instructions"("exercise_id", "info");
CREATE INDEX "workout_name_search" ON "workouts"("name");

-- Visualization
CREATE VIEW "ExercisesDB" AS
    SELECT
    "exercises"."name" as "Exercise",
    "muscles"."name" as "Muscle",
    "equipments"."name" as "Equipment",
    "levels"."type" as "Level",
    "instructions"."info" as "Instructions"

    FROM "exercises"
    JOIN "muscles" on "exercises"."muscle_id" = "muscles"."id"
    JOIN "equipments" on "exercises"."equipment_id" = "equipments"."id"
    JOIN "levels" on "exercises"."level_id" = "levels"."id"
    JOIN "instructions" on "exercises"."id" = "instructions"."exercise_id";

CREATE VIEW "WorkoutsDB" AS
    SELECT
    "workouts"."name" as "Workout",
    "exercises"."name" as "Exercise",
    "assigns"."kg" as "Weight(KG)",
    "assigns"."sets" as "Sets",
    "assigns"."reps" as "Reps"
    FROM "assigns"
    JOIN "workouts" ON "assigns"."workout_id" = "workouts"."id"
    JOIN "exercises" ON "assigns"."exercise_id" = "exercises"."id";

-- Predefined Data.
INSERT INTO "levels"("type")
VALUES
('beginner'),
('intermediate'),
('expert');


INSERT INTO "muscles"("name")
VALUES
('abdominals'),
('abductors'),
('adductors'),
('biceps'),
('calves'),
('chest'),
('forearms'),
('glutes'),
('hamstrings'),
('lats'),
('lower_back'),
('middle_back'),
('neck'),
('quadriceps'),
('traps'),
('triceps');

INSERT INTO "equipments"("name")
VALUES
('dumbbell'),
('barbell'),
('kettlebells'),
('cable'),
('bands'),
('foam_roll'),
('machine'),
('e-z_curl_bar'),
('other'),
('body_only'),
('None');




