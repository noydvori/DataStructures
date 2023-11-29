# Return the customer’s full name (in one column), the film title and the rental duration in weeks
# (rounded to the first 4 decimal points) of the longest film rental.
USE sakila;
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS FULL_NAME,
       film.title,
       ROUND(DATEDIFF(rental.return_date, rental.rental_date) / 7,4) AS duration
FROM customer,
     rental,
     film,
     inventory
WHERE rental.customer_id = customer.customer_id
  AND film.film_id = inventory.film_id
  AND rental.inventory_id = inventory.inventory_id
  AND  ROUND(DATEDIFF(rental.return_date, rental.rental_date) / 7,4) >= ALL
      ((SELECT MAX(MAX_DURATION)
        FROM (SELECT ROUND(DATEDIFF(rental.return_date, rental.rental_date) / 7,4) AS MAX_DURATION
              FROM rental)
             AS DURATION));
