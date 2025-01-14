/* Query 3 - query used for third insight */

-- In April 2007, which rental rates resulted in the most rentals per store? --
SELECT
	RENTAL_RATE,
	I.STORE_ID,
	COUNT(*)
FROM
	FILM F
	JOIN INVENTORY I ON F.FILM_ID = I.FILM_ID
	JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
	JOIN PAYMENT P ON R.RENTAL_ID = P.RENTAL_ID
WHERE
	DATE_PART('year', PAYMENT_DATE) = 2007
	AND DATE_PART('month', PAYMENT_DATE) = 4
GROUP BY 1,	2