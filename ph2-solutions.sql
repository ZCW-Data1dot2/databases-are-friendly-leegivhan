/* SQL "Sakila" database query exercises - phase 1 */

-- Database context
USE sakila;

-- Your solutions...
--Use google as lightly as possible in solving these. These are the kind of queries that any data engineer should be able to perform on a familiar dataset.
--
--* 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name
FROM sakila.actor
GROUP BY first_name, last_name;

--* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
--
SELECT UPPER(CONCAT(first_name, SPACE(1), last_name)) AS 'Actor Name'
FROM sakila.actor;
--
--* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
--
SELECT first_name, last_name
FROM sakila.actor
WHERE first_name = 'Joe';
--
--* 2b. Find all actors whose last name contain the letters `GEN`:
--
SELECT first_name, last_name
FROM sakila.actor
WHERE first_name
LIKE '%GEN%';
--
--* 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
--
SELECT last_name, first_name
FROM sakila.actor
WHERE last_name LIKE '%LI%'
GROUP BY last_name, first_name;
--
--* 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
--
SELECT country_id, country
FROM sakila.country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
--
--* 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
--
ALTER TABLE sakila.actor
ADD COLUMN middle_name VARCHAR(25)
AFTER first_name;
--
--* 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
--
ALTER TABLE sakila.actor
CHANGE middle_name blobs VARCHAR(25);
--
--* 3c. Now delete the `middle_name` column.
--
ALTER TABLE sakila.actor
DROP blobs;
--
--* 4a. List the last names of actors, as well as how many actors have that last name.
--
SELECT last_name, count(last_name) FROM sakila.actor
GROUP BY last_name
ORDER BY count(last_name) DESC;
--
--* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
--
SELECT last_name, count(last_name) FROM sakila.actor
GROUP BY last_name
HAVING count(last_name) >= 2
ORDER BY count(last_name) DESC;
--
--* 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
--
UPDATE sakila.actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS';
--
--* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)
--
UPDATE sakila.actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO'
AND last_name = 'WILLIAMS';
--
--* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
--
Create database address;

Show databases;
--
--  * Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)
--
--* 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
--
SELECT first_name, last_name, address
FROM sakila.staff st
	JOIN sakila.address ad
		ON st.staff_id = ad.address_id;
--
--* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
--
SELECT payment_id, first_name, last_name, SUM(amount)
	FROM sakila.staff st
		JOIN sakila.payment pay
			ON st.staff_id = pay.payment_id
GROUP BY payment_id, first_name, last_name;
--
--* 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
--
SELECT title, SUM(actor_id)
FROM sakila.film f
	INNER JOIN sakila.film_actor fa
		ON f.film_id = fa.film_id
GROUP BY title;
--
--* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
--
SELECT title, COUNT(inventory_id)
FROM sakila.film f
	JOIN sakila.inventory i
		ON f.film_id = i.film_id
WHERE title = 'Hunchback Impossible'
GROUP BY title;
--
--* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name
--
SELECT c.first_name AS 'First Name',
c.last_name AS 'Last Name',
SUM(p.amount) AS 'Total Paid'
FROM sakila.customer c
	JOIN sakila.payment p
		ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name;
--
--* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
--
SELECT title FROM sakila.film
WHERE title LIKE 'K%'
OR title LIKE 'Q%'
AND title IN
(
SELECT title
FROM sakila.film
WHERE language_id = 1
);
--
--* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
--
SELECT f.title, a.first_name, a.last_name
FROM sakila.actor a
	JOIN sakila.film_actor fa
		ON fa.actor_id = a.actor_id
	JOIN sakila.film f
		ON f.film_id = fa.film_id
WHERE title IN
(SELECT title FROM sakila.film
WHERE title = 'Alone Trip')
--
--* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
--
--* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
--
--* 7e. Display the most frequently rented movies in descending order.
--
--* 7f. Write a query to display how much business, in dollars, each store brought in.
--
--* 7g. Write a query to display for each store its store ID, city, and country.
--
--* 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
-- starting...
SELECT c.name, p.amount
FROM sakila.category c
	JOIN sakila.film_category fc
		ON fc.category_id = c.category_id
	JOIN sakila.inventory i
		ON i.film_id = f.film_id
	JOIN sakila.rental r
		ON r.inventory_id = i.inventory_id
--* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
--
--* 8b. How would you display the view that you created in 8a?
--
--* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.