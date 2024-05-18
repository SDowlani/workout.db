-- Search exercises by Muscle.
SELECT "Exercise", "Equipment", "Level"
FROM "ExercisesDB"
WHERE "Muscle" = 'biceps';

-- Search exercises by Equipment
SELECT "Exercise", "Muscle", "Level"
FROM "ExercisesDB"
WHERE "Equipment" = 'dumbbell';

-- Search exercises by Level
SELECT "Exercise", "Muscle", "Equipment"
FROM "ExercisesDB"
WHERE "Level" = 'beginner';

-- Search instructions by Exercise
SELECT "Instructions" FROM "ExercisesDB"
WHERE "Exercise"  = 'Barbell Curl';

-- Register people.
INSERT INTO "people"("first_name", "last_name", "email", "number")
VALUES
('Jimmy', 'Neutron', 'jimmyneutron@harvard.edu', '1234567'),
('Mr', 'Bean', 'mrbean@harvard.edu', 'teddy');

-- Create a new workout plan.
INSERT INTO "workouts"("name", "person_id")
VALUES
('Jimmy Biceps', (SELECT "id" FROM "people" WHERE "email" = 'jimmyneutron@harvard.edu')),
('Beans Monday', (SELECT "id" FROM "people" WHERE "email" = 'mrbean@harvard.edu'));

-- Assign exercises to a workout
INSERT INTO "assigns"("workout_id", "exercise_id", "kg", "sets", "reps")
VALUES
    (
    (SELECT "id" FROM "workouts" WHERE "name" = 'Jimmy Biceps'),
    (SELECT "id" FROM "exercises" WHERE "name" LIKE '%biceps%'),
    3,2,5
    ),
    (
        (SELECT "id" FROM "workouts" WHERE "name" = 'Jimmy Biceps'),
        (SELECT "id" FROM "exercises" WHERE "name" LIKE 'hammer%'),
        3, 3, 10
    ),
    (
        (SELECT "id" FROM "workouts" WHERE "name" = 'Jimmy Biceps'),
        (SELECT "id" FROM "exercises" WHERE "name" = 'Barbell Curl'),
        3, 5, 5
    ),
    (
        (SELECT "id" FROM "workouts" WHERE "name" = 'Beans Monday'),
        (SELECT "id" FROM "exercises" WHERE "name" = 'Rower'),
        15, 3, 10
    ),
    (
        (SELECT "id" FROM "workouts" WHERE "name" = 'Beans Monday'),
        (SELECT "id" FROM "exercises" WHERE "name" = 'Superman'),
        5, 3, 12
    );


-- Track Workout Programs
SELECT "Exercise", "Weight(KG)", "Sets", "Reps"
FROM "WorkoutsDB"
WHERE "Workout" = 'Jimmy Biceps';
