-- Формирование отчета о выявлении продавцов с выручкой ниже средней.
WITH
each_avg AS (
    SELECT
        e.first_name,
        e.last_name,
        FLOOR(SUM(s.quantity * p.price) / COUNT(*)) AS average_income
    FROM
        employees AS e
    INNER JOIN sales AS s ON e.employee_id = s.sales_person_id
    INNER JOIN products AS p ON s.product_id = p.product_id
    GROUP BY
        e.first_name,
        e.last_name
),

total_avg AS (
    SELECT AVG(average_income) AS t_avg
    FROM
        each_avg
)

SELECT
    average_income,
    CONCAT(first_name, ' ', last_name) AS seller
FROM
    each_avg
CROSS JOIN total_avg
WHERE
    t_avg > average_income
ORDER BY
    average_income ASC;
