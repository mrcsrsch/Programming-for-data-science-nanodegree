/* This code answers the question sets */

-- Q1 --
WITH film_category_rentals as (SELECT f.title, c.name as category, r.rentals
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id 
JOIN category c ON c.category_id = fc.category_id 
JOIN (SELECT film_id, count(*) rentals
	  FROM rental r
	  JOIN inventory i ON r.inventory_id = i.inventory_id
	  GROUP BY film_id) r ON r.film_id = f.film_id)

SELECT * 
FROM film_category_rentals
WHERE category IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family');

-- Q2 -- 
/* Note that this is different than the model answer. The model answer applies WHERE immediate on expression a. 
That means quartiles are calculated on the restricted set of films. */

WITH category_grouping as (SELECT 	f.title,
		c.name as category, 
		f.rental_duration, 
		NTILE(4) OVER(ORDER BY f.rental_duration) as duration_rank
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id 
JOIN category c ON c.category_id = fc.category_id) 

SELECT *
FROM category_grouping
WHERE category IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family');


/* This answer mirrors the model answer: */

WITH category_grouping as (SELECT 	f.title,
		c.name as category, 
		f.rental_duration, 
		NTILE(4) OVER(ORDER BY f.rental_duration) as duration_rank
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id 
JOIN category c ON c.category_id = fc.category_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family')) 

SELECT *
FROM category_grouping;


-- Q3 -- 
-- This answer mirrors the model answer, see code for Q2: --
WITH a as (SELECT 	f.title,
		c.name as category, 
		f.rental_duration, 
		NTILE(4) OVER(ORDER BY f.rental_duration) as duration_rank
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id 
JOIN category c ON c.category_id = fc.category_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')) 

SELECT category, duration_rank, count(*)
FROM a
GROUP BY 1,2
ORDER BY 1,2;

-- SECOND SET --
-- Q1 --
SELECT s.store_id, DATE_PART('year', rental_date) rental_year, DATE_PART('month', rental_date) rental_month, count(*)
FROM staff s
JOIN rental r ON s.staff_id = r.staff_id
GROUP BY 1,2,3
ORDER BY 4 DESC;

-- Q2 --
WITH top_customers as (SELECT customer_id, SUM(amount)
FROM payment p
WHERE DATE_PART('year', payment_date) = 2007
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10)

SELECT c.first_name || ' ' || c.last_name customer_name, 
	   DATE_TRUNC('month', p.payment_date) rental_month, 
	   count(*) pay_countpermon,
	   SUM(amount) pay_amount
FROM top_customers t
JOIN customer c ON c.customer_id = t.customer_id
JOIN payment p ON p.customer_id = t.customer_id
GROUP BY 1,2
ORDER BY 1,2;

-- Q3 -- 
WITH
	TOP_CUSTOMERS AS (
		SELECT CUSTOMER_ID, SUM(AMOUNT)
		FROM PAYMENT P
		WHERE DATE_PART('year', PAYMENT_DATE) = 2007
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10
	),
	PAYMENTS AS (
		SELECT 	C.FIRST_NAME || ' ' || C.LAST_NAME CUSTOMER_NAME,
			   	DATE_TRUNC('month', P.PAYMENT_DATE) RENTAL_MONTH,
				COUNT(*) PAY_COUNTPERMON,
				SUM(AMOUNT) PAY_AMOUNT
		FROM TOP_CUSTOMERS T
			JOIN CUSTOMER C ON C.CUSTOMER_ID = T.CUSTOMER_ID
			JOIN PAYMENT P ON P.CUSTOMER_ID = T.CUSTOMER_ID
		GROUP BY 1, 2
		ORDER BY 1, 2
	)
SELECT
	CUSTOMER_NAME, RENTAL_MONTH, PAY_AMOUNT,
	LAG(PAY_AMOUNT) OVER (PARTITION BY CUSTOMER_NAME ORDER BY RENTAL_MONTH) PAY_LAG,
	PAY_AMOUNT - LAG(PAY_AMOUNT) OVER (PARTITION BY CUSTOMER_NAME ORDER BY RENTAL_MONTH) PAY_DIFFERENCE
FROM PAYMENTS
ORDER BY 5 DESC;




