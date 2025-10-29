-- Формирование отчета о выручке продавцов по дням недели.
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS seller,
    CASE
        WHEN EXTRACT(ISODOW FROM s.sale_date) = 1 THEN 'Monday'
        WHEN EXTRACT(ISODOW FROM s.sale_date) = 2 THEN 'Tuesday'
        WHEN EXTRACT(ISODOW FROM s.sale_date) = 3 THEN 'Wednesday'
        WHEN EXTRACT(ISODOW FROM s.sale_date) = 4 THEN 'Thursday'
        WHEN EXTRACT(ISODOW FROM s.sale_date) = 5 THEN 'Friday'
        WHEN EXTRACT(ISODOW FROM s.sale_date) = 6 THEN 'Saturday'
        WHEN EXTRACT(ISODOW FROM s.sale_date) = 7 THEN 'Sunday'
    END AS day_of_week,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM sales AS s
INNER JOIN customers AS c
    ON s.customer_id = c.customer_id
INNER JOIN products AS p
    ON s.product_id = p.product_id
GROUP BY
    CONCAT(c.first_name, ' ', c.last_name),
    EXTRACT(ISODOW FROM s.sale_date)
ORDER BY
    EXTRACT(ISODOW FROM s.sale_date),
    seller;
