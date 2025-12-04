--SOLUTIONS FOE CLINIC_SCHEMA_SETUP--

1. Find the revenue we got from each sales channel in a given year 

SELECT 
    clinic_sales.sales_channel AS sales_channel_name,
    SUM(clinic_sales.amount) AS total_revenue
FROM clinic_sales
WHERE clinic_sales.datetime LIKE '2021%'
GROUP BY clinic_sales.sales_channel;

2. Find top 10 the most valuable customers for a given year 

SELECT 
    customer.name AS customer_name,
    SUM(clinic_sales.amount) AS total_spent
FROM customer
JOIN clinic_sales ON customer.uid = clinic_sales.uid
WHERE clinic_sales.datetime LIKE '2021%'
GROUP BY customer.uid, customer.name
ORDER BY total_spent DESC
LIMIT 10;

3. Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given year 

SELECT
    SUBSTR(clinic_sales.datetime, 1, 7) AS month_year,
    SUM(clinic_sales.amount) AS total_revenue,
    CASE 
        WHEN expense_summary.total_expense IS NULL THEN 0
        ELSE expense_summary.total_expense
    END AS total_expense,
    SUM(clinic_sales.amount) -
        CASE 
            WHEN expense_summary.total_expense IS NULL THEN 0
            ELSE expense_summary.total_expense
        END AS profit,
    CASE 
        WHEN SUM(clinic_sales.amount) -
            CASE 
                WHEN expense_summary.total_expense IS NULL THEN 0
                ELSE expense_summary.total_expense
            END >= 0 THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM clinic_sales
LEFT JOIN (
    SELECT 
        SUBSTR(expenses.datetime, 1, 7) AS month_year,
        SUM(expenses.amount) AS total_expense
    FROM expenses
    WHERE expenses.datetime LIKE '2021%'
    GROUP BY SUBSTR(expenses.datetime, 1, 7)
) AS expense_summary
ON SUBSTR(clinic_sales.datetime, 1, 7) = expense_summary.month_year
WHERE clinic_sales.datetime LIKE '2021%'
GROUP BY SUBSTR(clinic_sales.datetime, 1, 7)
ORDER BY month_year;

4. For each city find the most profitable clinic for a given month 

WITH clinic_profit AS (
    SELECT
        clinics.city AS city_name,
        clinics.clinic_name AS clinic_name,
        SUM(clinic_sales.amount) AS total_revenue,

        COALESCE(
            (
                SELECT SUM(expenses.amount)
                FROM expenses
                WHERE expenses.cid = clinics.cid
                  AND expenses.datetime LIKE '2021-09%'
            ), 
            0
        ) AS total_expense

    FROM clinics
    JOIN clinic_sales 
        ON clinics.cid = clinic_sales.cid
    WHERE clinic_sales.datetime LIKE '2021-09%'
    GROUP BY clinics.city, clinics.clinic_name
),

profit_calculation AS (
    SELECT
        city_name,
        clinic_name,
        (total_revenue - total_expense) AS total_profit
    FROM clinic_profit
),

ranked_clinics AS (
    SELECT 
        *,
        ROW_NUMBER() OVER(
            PARTITION BY city_name
            ORDER BY total_profit DESC
        ) AS row_number_position
    FROM profit_calculation
)

SELECT 
    city_name, 
    clinic_name, 
    total_profit
FROM ranked_clinics
WHERE row_number_position = 1

5. For each state find the second least profitable clinic for a given month 

WITH clinic_profit AS (
    SELECT
        clinics.state AS state_name,
        clinic_sales.cid AS clinic_identifier,
        SUM(clinic_sales.amount) AS total_revenue,
        (
            SELECT SUM(expenses.amount)
            FROM expenses
            WHERE expenses.cid = clinic_sales.cid
              AND expenses.datetime LIKE '2021-05%'
        ) AS total_expense
    FROM clinic_sales
    JOIN clinics 
        ON clinic_sales.cid = clinics.cid
    WHERE clinic_sales.datetime LIKE '2021-05%'
    GROUP BY clinics.state, clinic_sales.cid
),

ranked_clinics AS (
    SELECT
        state_name,
        clinic_identifier,
        total_revenue,
        COALESCE(total_expense, 0) AS total_expense,
        (total_revenue - COALESCE(total_expense, 0)) AS profit_value,
        ROW_NUMBER() OVER (
            PARTITION BY state_name
            ORDER BY (total_revenue - COALESCE(total_expense, 0)) ASC
        ) AS row_number_position
    FROM clinic_profit
)

SELECT
    state_name,
    clinic_identifier,
    profit_value
FROM ranked_clinics
WHERE row_number_position = 2

UNION ALL

SELECT
    state_name,
    clinic_identifier,
    profit_value
FROM ranked_clinics
WHERE row_number_position = 1
  AND state_name NOT IN (
        SELECT state_name 
        FROM ranked_clinics 
        WHERE row_number_position = 2
    );
