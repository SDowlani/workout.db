import argparse
import textwrap
import os
from sqlite3 import connect as create
from cs50 import SQL
import requests

# Getting the API Key from the CMDLine
parser = argparse.ArgumentParser(
	formatter_class=argparse.RawDescriptionHelpFormatter,
	description=textwrap.dedent('''\
		Creates a new instance of workout.db using your "Exercises API Key" FROM API Ninjas
		Which will then fetch all of the exercises and insert into the db.
		For more information acess: https://api-ninjas.com/api/exercises
		PS: It's Free :)
		'''))
parser.add_argument('key', type=str, help='Your Ninjas Exercise API Key Here')

args = parser.parse_args()

key = args.key

# Creating the database, using sqlite3 modules which eases file IO.
db = create("workout.db")

# Read schema into the database.
with open("schema.sql") as file:
	schema = file.read()
	db.executescript(schema)

# End sqlite3 database connection.
db.close()

# Connect to database using CS50'S SQL modules which eases database querying.
db = SQL("sqlite:///workout.db")

# Fetch "muscles"
query = db.execute("SELECT name FROM muscles")

# For each muscle, Insert into "exercises" using the data gathered by the Ninjas API.
for row in query:
	exercises = requests.get(
	"https://api.api-ninjas.com/v1/exercises?muscle={}".format(row['name']),
	headers = {"X-Api-Key": key}
	).json()
	for exercise in exercises:
		db.execute(
		"""
		INSERT INTO exercises(name, muscle_id, equipment_id, level_id)
		VALUES
		(?, (SELECT id FROM muscles WHERE name = ?), (SELECT id FROM equipments WHERE name = ?), (SELECT id FROM levels WHERE type = ?));
		""",
		exercise['name'], exercise['muscle'], exercise['equipment'], exercise['difficulty']
		)

		db.execute(
		"""
		INSERT INTO instructions(exercise_id, info)
		VALUES
		(
		(SELECT id FROM exercises WHERE name = ?),?);
		""",
		exercise['name'], exercise['instructions']
		)



