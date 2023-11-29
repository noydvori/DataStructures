# Getting the average number of films an actor has been in, and then getting the actors who have been in more than 10
# films more than the average.
USE sakila;
SELECT DISTINCT actor.first_name, actor.last_name
FROM actor,
     film_actor,
     film
WHERE film.film_id = film_actor.film_id
  AND actor.actor_id = film_actor.actor_id
GROUP BY film_actor.actor_id, actor.first_name, actor.last_name
HAVING (COUNT(film_actor.actor_id) >= (10 + (SELECT AVG(count)
                                             FROM (SELECT COUNT(film_actor.actor_id) AS count
                                                   FROM film_actor,
                                                        actor
                                                   WHERE actor.actor_id = film_actor.actor_id
                                                   GROUP BY film_actor.actor_id) AS avg_count)))
ORDER BY actor.first_name, actor.last_name




