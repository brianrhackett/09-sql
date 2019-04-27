use sakila;
-- 1a
SELECT first_name, last_name FROM actor;

-- 1b
SELECT upper(concat(first_name,' ',last_name)) as `Actor Name` from actor;

----

-- 2a
SELECT actor_id,last_name FROM actor WHERE first_name = 'Joe';

-- 2b
SELECT * FROM actor WHERE last_name LIKE '%GEN%';

-- 2c
SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name,first_name;

-- 2d
SELECT country_id,country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

----

-- 3a
ALTER TABLE actor ADD COLUMN description BLOB;

-- 3b
ALTER TABLE actor DROP COLUMN description;

----

-- 4a
SELECT last_name, COUNT(last_name) as last_name_count FROM actor GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(last_name) as last_name_count FROM actor a1 WHERE (SELECT COUNT(a2.last_name) from actor a2 WHERE a2.last_name = a1.last_name) >= 2 GROUP BY a1.last_name;

-- 4c
UPDATE actor SET first_name = 'Harpo' WHERE first_name = 'Groucho' AND last_name = 'Williams';

-- 4d
UPDATE actor SET first_name = 'Groucho' WHERE first_name = 'Groucho';

----

-- 5a
SHOW CREATE TABLE address;

----

-- 6a
SELECT s.first_name, s.last_name, a.address 
FROM staff s
INNER JOIN address a ON a.address_id = s.address_id;

-- 6b
SELECT s.first_name, s.last_name, SUM(p.amount) as amt 
FROM staff s
INNER JOIN payment p ON p.staff_id = s.staff_id
GROUP BY s.staff_id;

-- 6c
SELECT f.title, COUNT(fa.actor_id) as actor_count
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.film_id;

-- 6d
SELECT count(inventory_id) as inventory_count
FROM inventory
LEFT JOIN film ON film.film_id = inventory.film_id
WHERE film.title = "Hunchback Impossible";

-- 6e
SELECT c.first_name, c.last_name, SUM(p.amount)
FROM customer c
LEFT JOIN payment p ON p.customer_id = c.customer_id
GROUP BY p.customer_id
ORDER BY c.last_name;

----

-- 7a
SELECT title
FROM film
WHERE (title LIKE 'Q%' OR title LIKE 'K%')
AND (SELECT lang.language_id FROM `language` lang WHERE `name` = 'English') = film.language_id;

-- 7b
SELECT a.first_name, a.last_name, a.actor_id
FROM actor a
WHERE 
	(SELECT f.film_id FROM film f WHERE f.title = "Alone Trip") IN 
	(SELECT CONCAT(fa.film_id) FROM film_actor fa WHERE fa.actor_id = a.actor_id);

-- 7c
SELECT c.first_name, c.last_name, c.email
FROM customer c
LEFT JOIN address a ON a.address_id = c.address_id
INNER JOIN city ON city.city_id = a.city_id
INNER JOIN country ON country.country_id = city.country_id
WHERE country.country = 'Canada';

-- 7d
SELECT f.title
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'family';

-- 7e
SELECT f.title, COUNT(r.rental_id) as rented_amt
FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.film_id
ORDER BY COUNT(r.rental_id) desc;

-- 7f
SELECT store.store_id, SUM(p.amount) as dollars
FROM store 
LEFT JOIN staff ON store.store_id = staff.store_id
INNER JOIN payment p ON staff.staff_id = p.staff_id
GROUP BY store.store_id;

-- 7g
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address a ON a.address_id = store.address_id
INNER JOIN city ON city.city_id = a.city_id
INNER JOIN country ON country.country_id = city.country_id;

-- 7h
SELECT cat.name, SUM(p.amount)
FROM category cat
INNER JOIN film_category fc ON fc.category_id = cat.category_id
INNER JOIN film f ON f.film_id = fc.film_id
INNER JOIN inventory i ON i.film_id = f.film_id
INNER JOIN rental r ON r.inventory_id = i.inventory_id
LEFT JOIN payment p ON p.rental_id = r.rental_id
GROUP BY fc.category_id
ORDER BY SUM(p.amount)
LIMIT 0,5;

----

-- 8a
CREATE VIEW top_genres AS
SELECT cat.name, SUM(p.amount)
FROM category cat
INNER JOIN film_category fc ON fc.category_id = cat.category_id
INNER JOIN film f ON f.film_id = fc.film_id
INNER JOIN inventory i ON i.film_id = f.film_id
INNER JOIN rental r ON r.inventory_id = i.inventory_id
LEFT JOIN payment p ON p.rental_id = r.rental_id
GROUP BY fc.category_id
ORDER BY SUM(p.amount)
LIMIT 0,5;

-- 8b
SELECT * FROM top_genres;

-- 8c
DROP VIEW top_genres;