-- Отчёт о по количеству уникальных покупателей и выручке, которую они принесли.
SELECT
    TO_CHAR(s.sale_date, 'YYYY-MM') AS selling_month,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM sales AS s
INNER JOIN customers AS c
    ON s.customer_id = c.customer_id
INNER JOIN products AS p
    ON s.product_id = p.product_id
GROUP BY TO_CHAR(s.sale_date, 'YYYY-MM')
ORDER BY selling_month;
