# For each pair of non-identical titles of the same film_id, return the title from the film table and the title from
# the film_text table. Order the results alphabetically by the title from the film table.
USE sakila;
SELECT film.title, film_text.title
FROM film,
     film_text
WHERE film.film_id = film_text.film_id
  AND film.title <> film_text.title
ORDER BY film.title;