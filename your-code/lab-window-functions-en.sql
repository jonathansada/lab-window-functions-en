-- Q1:
SELECT
    title,
    rental_duration,
    AVG(rental_duration) OVER (PARTITION BY title) AS avg_rental_duration
FROM
    film;
	
SELECT film.title, film.rental_duration, AVG((JulianDay(rental.return_date) - JulianDay(rental.rental_date))) OVER (PARTITION BY film.film_id) AS avg_rental_duration
FROM film
	INNER JOIN inventory on film.film_id = inventory.film_id
	INNER JOIN rental on inventory.inventory_id = rental.inventory_id;
	

-- Q2:
SELECT
    staff_id,
    AVG(amount) OVER (PARTITION BY staff_id) AS avg_payment_amount
FROM
    payment;
	
-- Q3:
SELECT
    payment.customer_id,
    rental_id,
    rental_date,
    amount,
    SUM(amount) OVER (PARTITION BY payment.customer_id ORDER BY rental_date) AS running_total
FROM
    payment
    JOIN rental USING (rental_id)
ORDER BY
    payment.customer_id, rental_date;
	
-- Q4:
-- Your code down below
SELECT
    title,
    rental_rate,
    NTILE(4) OVER (ORDER BY rental_rate) AS quartile
FROM
    film;
	
-- Q5:
SELECT
    customer_id,
    MIN(rental_date) OVER (PARTITION BY customer_id) AS first_rental_date,
    MAX(rental_date) OVER (PARTITION BY customer_id) AS last_rental_date
FROM
    rental;
	
-- Q6.
SELECT
    customer_id,
    rental_count,
    RANK() OVER (ORDER BY rental_count DESC) AS rental_count_rank
FROM (
    SELECT
        customer_id,
        COUNT(rental_id) AS rental_count
    FROM
        rental
    GROUP BY
        customer_id
) AS rental_counts;

-- Q7:
SELECT
    film_category,
    rental_date,
    amount,
    SUM(amount) OVER (PARTITION BY rental_date ORDER BY rental_date) AS daily_revenue
FROM (
    SELECT
        f.title AS film_category,
        r.rental_date,
        p.amount
    FROM
        film AS f
        JOIN inventory AS i ON f.film_id = i.film_id
        JOIN rental AS r ON i.inventory_id = r.inventory_id
        JOIN payment AS p ON r.rental_id = p.rental_id
    WHERE
        f.rating = 'G'
) AS daily_revenue;

-- Q8:
SELECT
    customer_id,
    payment_id,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date) AS payment_sequence_id
FROM
    payment;
	
-- Q9:
SELECT
    customer_id,
    rental_id,
    rental_date,
    LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS previous_rental_date,
    (JulianDay(rental.return_date) - LAG(JulianDay(rental.rental_date)) OVER (PARTITION BY customer_id ORDER BY rental_date)) AS days_between_rentals
FROM
    rental
ORDER BY
    customer_id, rental_date;