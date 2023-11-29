# Finding the customer who rented the most movies in May 2005.
USE sakila;
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS FULL_NAME
FROM customer,
     rental
WHERE rental.customer_id = customer.customer_id
  AND rental.rental_date BETWEEN '2005-05-01' AND '2005-05-31'
GROUP BY rental.customer_id
HAVING COUNT(rental.customer_id) >= ALL (SELECT COUNT(rental.customer_id)
                                         FROM rental
                                         WHERE rental.rental_date BETWEEN '2005-05-01' AND '2005-05-31'
                                         GROUP BY rental.customer_id);


