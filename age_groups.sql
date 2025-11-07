-- Отчёт по количеству покупателей в разных возрастных группах.
WITH age_group AS (
    SELECT
        CASE
            WHEN age BETWEEN 16 AND 25 THEN '16-25'
            WHEN age BETWEEN 26 AND 40 THEN '26-40'
            ELSE '40+'
        END AS age_category,
        COUNT(customer_id) AS age_count
    FROM customers
    WHERE age >= 16
    GROUP BY
        CASE
            WHEN age BETWEEN 16 AND 25 THEN '16-25'
            WHEN age BETWEEN 26 AND 40 THEN '26-40'
            ELSE '40+'
        END
)

SELECT
    age_category,
    age_count
FROM age_group
ORDER BY age_category;
