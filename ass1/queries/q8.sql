# Find all customers and actors that do not have an actor or customer respectively with the same
# first name
USE sakila;
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.first_name NOT IN (SELECT customer.first_name FROM customer)

UNION

SELECT customer.first_name, customer.last_name
FROM customer
WHERE customer.first_name NOT IN (SELECT actor.first_name FROM actor)

ORDER BY first_name
