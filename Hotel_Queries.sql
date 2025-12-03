--SOLUTIONS FOR HOTEL_SCHEMA_SETUP--

1. For every user in the system, get the user_id and last booked room_no 

SELECT users.user_id, bookings.room_no
FROM users
JOIN bookings
     ON users.user_id = bookings.user_id
WHERE bookings.booking_date = (
    SELECT MAX(bookings.booking_date)
    FROM bookings
    WHERE bookings.user_id = users.user_id
);

2. Get booking_id and total billing amount of every booking created in November, 2021 

SELECT bookings.booking_id, 
       SUM(booking_commercials.item_quantity * items.item_rate) AS total_amount
FROM bookings
JOIN booking_commercials
     ON bookings.booking_id = booking_commercials.booking_id
JOIN items
     ON booking_commercials.item_id = items.item_id
WHERE bookings.booking_date >= '2021-11-01'
  AND bookings.booking_date < '2021-12-01'
GROUP BY bookings.booking_id;

3. Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount >1000 

SELECT booking_commercials.bill_id,
       SUM(booking_commercials.item_quantity * items.item_rate) AS bill_amount
FROM booking_commercials
JOIN items
     ON booking_commercials.item_id = items.item_id
WHERE booking_commercials.bill_date >= '2021-10-01'
  AND booking_commercials.bill_date < '2021-11-01'
GROUP BY booking_commercials.bill_id
HAVING SUM(booking_commercials.item_quantity * items.item_rate) > 1000;

4. Determine the most ordered and least ordered item of each month of year 2021

SELECT month_data.month,
       month_data.item_name,
       month_data.total_quantity
FROM (
    SELECT strftime('%m', booking_commercials.bill_date) AS month,
           items.item_name,
           SUM(booking_commercials.item_quantity) AS total_quantity
    FROM booking_commercials
    JOIN items
         ON booking_commercials.item_id = items.item_id
    WHERE booking_commercials.bill_date >= '2021-01-01'
      AND booking_commercials.bill_date < '2022-01-01'
    GROUP BY strftime('%m', booking_commercials.bill_date), items.item_name
) AS month_data
WHERE month_data.total_quantity = (
    SELECT MAX(month_total.total_quantity)
    FROM (
        SELECT SUM(booking_commercials.item_quantity) AS total_quantity
        FROM booking_commercials
        JOIN items
             ON booking_commercials.item_id = items.item_id
        WHERE strftime('%m', booking_commercials.bill_date) = month_data.month
        GROUP BY items.item_name
    ) AS month_total
)
OR month_data.total_quantity = (
    SELECT MIN(month_total.total_quantity)
    FROM (
        SELECT SUM(booking_commercials.item_quantity) AS total_quantity
        FROM booking_commercials
        JOIN items
             ON booking_commercials.item_id = items.item_id
        WHERE strftime('%m', booking_commercials.bill_date) = month_data.month
        GROUP BY items.item_name
    ) AS month_total
);


5. Find the customers with the second highest bill value of each month of year 2021 

SELECT month_data.month, month_data.user_id, month_data.total_bill
FROM (
    SELECT strftime('%Y-%m', booking_commercials.bill_date) AS month,
           bookings.user_id,
           SUM(booking_commercials.item_quantity * items.item_rate) AS total_bill,
           RANK() OVER (
               PARTITION BY strftime('%Y-%m', booking_commercials.bill_date) 
               ORDER BY SUM(booking_commercials.item_quantity * items.item_rate) DESC
           ) AS bill_rank
    FROM booking_commercials
    JOIN bookings
         ON booking_commercials.booking_id = bookings.booking_id
    JOIN items
         ON booking_commercials.item_id = items.item_id
    WHERE booking_commercials.bill_date >= '2021-01-01'
      AND booking_commercials.bill_date < '2022-01-01'
    GROUP BY month, bookings.user_id
) AS month_data
WHERE month_data.bill_rank = 2;





