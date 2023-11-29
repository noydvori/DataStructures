import os
import mysql.connector
from dotenv import load_dotenv

load_dotenv()

# connecting to database.
cnx = mysql.connector.connect(
    user='root',
    password=os.getenv('MYSQL_ROOT_PASSWORD'),
    host='127.0.0.1',
    database='sakila'
)

# create a cursor
cursor = cnx.cursor(prepared=True)

# if the tables do not exist, create them.
cursor.execute("""
CREATE TABLE IF NOT EXISTS reviewer (
        reviewer_id INT PRIMARY KEY, 
        first_name VARCHAR(45) NOT NULL,
        last_name VARCHAR(45) NOT NULL,
        CHECK(REGEXP_LIKE(reviewer_id, '^([0-9]+)$'))
    );
""")
# clearing the cursor before getting a new data
cursor.fetchall()

cursor.execute("""
    CREATE TABLE IF NOT EXISTS rating (
        film_id SMALLINT UNSIGNED NOT NULL,
        reviewer_id INT NOT NULL,
        rating DECIMAL(2,1) NOT NULL,
        CHECK(0 <= rating AND rating <= 9.9),
        PRIMARY KEY(film_id, reviewer_id),
        FOREIGN KEY(reviewer_id) REFERENCES reviewer(reviewer_id) ON UPDATE CASCADE ON DELETE CASCADE,
        FOREIGN KEY(film_id) REFERENCES film(film_id) ON UPDATE CASCADE ON DELETE CASCADE
    );
""")
# clearing the cursor before getting a new data
cursor.fetchall()

# searches for the viewer in Database, if it doesn't exist adds it as a new viewer.
while True:
    print("Please type your ID:")
    reviewerID = input()
    query = "SELECT reviewer_id, CONCAT(first_name,' ', last_name) as full_name FROM reviewer WHERE reviewer_id = %s"
    # Checking if the reviewerID is a number. If it is not a number, it will ask the user to enter the ID
    # again.
    try:
        cursor.execute(query, (int(reviewerID),))
    except:
        print("Invalid format. Name has to contain letters only and ID must have digits only.")
        continue
    pickedID = cursor.fetchall()
    # checking if the result is empty. If it is empty, it means that the reviewer is not in the database.
    if len(pickedID) == 0:
        # asking for the viewer's details.
        print("Please enter your first name:")
        firstName = input()
        print("Please enter your last name:")
        lastName = input()
        try:
            # adds the new viewer to the database
            query = "INSERT INTO reviewer(reviewer_id, first_name, last_name) VALUES(%s,%s,%s)"
            cursor.execute(query, (reviewerID, firstName, lastName))
            # It commits the changes to the database.
            cnx.commit()
        except:
            print("Invalid format. Name has to contain letters only and ID must have digits only.")
            continue
        print("Hello, " + firstName + " " + lastName)
    else:
        print("Hello, " + pickedID[0][1])
    break

# receiving a movie name from the user and checking for correctness, continues until a correct name is received.
while True:
    print("Please enter the film name:")
    filmName = input()
    query = "SELECT film_id, title, release_year FROM film WHERE title = %s"
    cursor.execute(query, (filmName,))
    pickedMovie = cursor.fetchall()
    # checking if the film exists in the database. If it doesn't exist, it will ask the user to enter the film name
    # again.
    if len(pickedMovie) == 0:
        print("The film doesn't exist.")
    else:
        if len(pickedMovie) > 1:
            for movie in pickedMovie:
                print("Film ID: " + str(movie[0]) + " | Name: " + str(movie[1]) + " | Year of Release: " +
                      str(movie[2]))
            print("Please enter your decision:")
            filmDecision = input()
            isFilm = False
            # checking if the film exists in the database:
            for movie in pickedMovie:
                try:
                    if movie[0] == int(filmDecision):
                        pickedMovie = movie
                        isFilm = True
                        break
                except:
                    break
            # stops the loop if a valid film is received.
            if isFilm:
                break
        else:
            pickedMovie = pickedMovie[0]
            break
        print("Invalid movie ID.")

# receives a rating for the selected movie and updates the database.
while True:
    print("Please enter a rating:")
    rating = input()
    try:
        query = "SELECT film_id, reviewer_id FROM rating WHERE film_id = %s AND reviewer_id = %s"
        cursor.execute(query, (pickedMovie[0], reviewerID))
        ratedMovie = cursor.fetchall()
        # Checking if the film exists in the database. If it doesn't exist, it will ask the user to enter the film name
        # again.
        if len(ratedMovie) > 0:
            # if the customer has already rated the movie, it is updated to the new rating, otherwise, adds a new
            # rating.
            query = "UPDATE rating SET rating = %s WHERE film_id = %s AND reviewer_id = %s"
            cursor.execute(query, (rating, pickedMovie[0], reviewerID))
        else:
            query = "INSERT INTO rating(film_id, reviewer_id, rating) VALUES(%s,%s,%s)"
            cursor.execute(query, (pickedMovie[0], reviewerID, rating))
        # It commits the changes to the database.
        cnx.commit()
        break
    except:
        print("Invalid rating, rating must be between 0 and 9.9")
        continue

# print to the reviewer all the ratings in the database, up to 100 results.
query = """
SELECT film.title, CONCAT(reviewer.first_name,' ', reviewer.last_name) as full_name, rating.rating 
FROM rating, reviewer, film
WHERE film.film_id = rating.film_id AND rating.reviewer_id = reviewer.reviewer_id
LIMIT 100
"""
cursor.execute(query)
ratings = cursor.fetchall()
for rating in ratings:
    print("Film Title: " + str(rating[0]) + " | Reviewer's Full Name: " + str(rating[1]) + " | Film Rating: " +
          str(rating[2]))

cnx.close()
