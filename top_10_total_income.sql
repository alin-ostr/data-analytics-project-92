-- Отчёт об определении десяти продавцов с наибольшей выручкой.
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS seller,
    COUNT(s.sales_person_id) AS operations,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM
    employees AS e
INNER JOIN sales AS s ON e.employee_id = s.sales_person_id
INNER JOIN products AS p ON s.product_id = p.product_id
GROUP BY
    CONCAT(e.first_name, ' ', e.last_name)
ORDER BY
    income DESC
LIMIT
    10;
