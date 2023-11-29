# Selecting the film_id and title from the film table where the length is less than 90 and the rating is either PG or G.
USE sakila;
SELECT film_id, title
FROM film
WHERE length < 90
  AND (rating = 'PG' OR rating = 'G');