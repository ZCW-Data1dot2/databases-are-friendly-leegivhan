/* SQL "Sakila" database query exercises - phase 1 */

-- Database context
USE sakila;

-- Your solutions...

--* Write an SQL script with queries that answer the following questions:

--* 1. Which actors have the first name ‘Scarlett’

SELECT * FROM sakila.actor
WHERE first_name = "Scarlett";

--Answers:  Scarlett Damon and Scarlett Bening

--* 2. Which actors have the last name ‘Johansson’

SELECT *
FROM sakila.actor a
WHERE a.last_name = "Johansson";

--Answer: Matthew, Ray and Albert Johansson

--* 3. How many distinct actors last names are there? 121

SELECT DISTINCT last_name FROM sakila.actor;

--Answer: 121

--* 4. Which last names are not repeated? 66

SELECT *
FROM sakila.actor a
WHERE NOT EXISTS (
SELECT 1
FROM sakila.actor b
WHERE a.last_name=b.last_name
HAVING COUNT(*)>1
)

--Answer: 66

--* 5. Which last names appear more than once? 200

SELECT *
FROM sakila.actor a
WHERE NOT EXISTS (
SELECT 1
FROM sakila.actor b
WHERE a.last_name=b.last_name
HAVING COUNT(*)<1
)

--Answer: 200

--* 6. Which actor has appeared in the most films?
SELECT actor_id, count(actor_id) as Total
FROM sakila.film_actor
GROUP BY actor_id
ORDER BY Total DESC;

SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id = 107
GROUP BY first_name, last_name;

--Answer: Actor_ID 107, Gina Degeneres

--* 7. Is ‘Academy Dinosaur’ available for rent from Store 1?
SELECT film_id, title
FROM sakila.film
GROUP BY film_id, title;
-- "Academy Dinosaur" film id is 1
SELECT film_id, store_id
FROM sakila.inventory
WHERE film_id = 1
AND store_id = 1;
-- Yes, there are 4 copies available from store 1

--* 8. Insert a record to represent Mary Smith renting ‘Academy Dinosaur’ from Mike Hillyer at Store 1 today .

SELECT staff_id, first_name, last_name
FROM sakila.staff
WHERE first_name = 'Mike'
AND last_name = 'Hillyer'
GROUP BY staff_id, first_name, last_name;

INSERT INTO sakila.rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (NOW(), 1, 1, 1)

--Double checking...
SELECT * FROM sakila.rental
WHERE inventory_id = 1;

--* 9. When is ‘Academy Dinosaur’ due?

SELECT * FROM sakila.rental
WHERE inventory_id = 1
AND customer_id = 1;

--Due: 'Null'

SELECT film_id, rental_duration
FROM sakila.film
WHERE film_id = 1
GROUP BY film_id, rental_duration;

--Rental duration = 6
--Due: '2020-12-12'

--* 10. What is that average running time of all the films in the sakila DB?

SELECT AVG(length)
FROM sakila.film;

Answer: '115.2720'

--* 11. What is the average running time of films by category?

SELECT category.name, avg(f.length)
FROM sakila.film f
JOIN sakila.film_category USING (film_id)
JOIN sakila.category USING (category_id)
GROUP BY category.name
ORDER BY avg(length) DESC;

+-------------+---------------+
| name        | avg(f.length) |
+-------------+---------------+
| Sports      |      128.2027 |
| Games       |      127.8361 |
| Foreign     |      121.6986 |
| Drama       |      120.8387 |
| Comedy      |      115.8276 |
| Family      |      114.7826 |
| Music       |      113.6471 |
| Travel      |      113.3158 |
| Horror      |      112.4821 |
| Classics    |      111.6667 |
| Action      |      111.6094 |
| New         |      111.1270 |
| Animation   |      111.0152 |
| Children    |      109.8000 |
| Documentary |      108.7500 |
| Sci-Fi      |      108.1967 |
+-------------+---------------+

--* 12. Why does this query return the empty set?

-- I don't understand... The previous exercise did not return an empty set.
