use sakila;
show tables;
desc film;
desc actor;
desc film_actor;

## which actor have the first name 'Scarlett'?

select first_name, last_name
from actor
where first_name = "Scarlett";

## which actors have the last name 'Johanson'?

select first_name, last_name
from actor
where last_name = "Johansson";

## How many distinct actors last names are there?

SELECT COUNT(DISTINCT last_name)
FROM actor
WHERE last_name IS NOT NULL;

## Which last names are not repeated?

SELECT last_name, COUNT(last_name) AS number_of_times_repeated
FROM actor
GROUP BY last_name
HAVING number_of_times_repeated = 1;

## Which last names appear more than once?

SELECT last_name, COUNT(last_name) AS number_of_times_repeated
FROM actor
GROUP BY last_name
HAVING number_of_times_repeated > 1;

## Which actor has appeared in the most films?

select * from film_actor f INNER JOIN actor a ON f.actor_id = a.actor_id
GROUP BY f.actor_id
ORDER BY COUNT(f.actor_id) DESC 
LIMIT 1;

## Is ‘Academy Dinosaur’ available for rent from Store 1?

select * from film f INNER JOIN inventory i ON i.film_id = f.film_id
WHERE i.store_id = 1 AND f.title = "Academy Dinosaur";

## Insert a record to represent Mary Smith renting ‘Academy Dinosaur’ from Mike Hillyer at Store 1 today.

INSERT INTO rental (inventory_id, customer_id,staff_id, return_date)
SELECT inventory_id, customer_id,staff_id,DATE_ADD(CURDATE(), INTERVAL 10 DAY)
FROM (
SELECT i.inventory_id, 1 as commonId 
FROM inventory i INNER JOIN film f ON i.film_id = f.film_id
WHERE f.title = "Academy Dinosaur" and i.store_id = 1
LIMIT 1
) AS tempA
INNER JOIN
(
SELECT customer_id, 1 as commonId 
FROM customer 
WHERE first_name = "Mary" AND last_name ="Smith"
) AS tempB

ON tempA.commonId = tempB.commonId

INNER JOIN(
SELECT staff_id, 1 as commonId
FROM staff
WHERE first_name ="Mike" AND last_name = "Hillyer" )AS tempC

ON tempB.commonId = tempC.commonId;

## When is ‘Academy Dinosaur’ due?

SELECT return_date
FROM rental r 
INNER JOIN inventory i ON i.inventory_id = r.inventory_id 
INNER JOIN  film f ON f.film_id = i.film_id 
WHERE f.title = "Academy Dinosaur"
ORDER BY return_date DESC;

## What is that average running time of all the films in the sakila DB?

SELECT AVG(length)
FROM film;