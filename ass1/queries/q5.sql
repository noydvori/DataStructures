# Finding the average length of films in each category.
USE sakila;
SELECT category.name, AVG(length) AS avg_length
FROM film,
     film_category,
     category
WHERE film.film_id = film_category.film_id
  AND category.category_id = film_category.category_id
GROUP BY category.category_id
