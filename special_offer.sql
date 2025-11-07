-- Отчёт о покупателях, чья первая покупка пришлась в день специальных акций
WITH first_sales AS (
    SELECT
        customer_id,
        MIN(sale_date) AS sale_date -- первая дата покупки
    FROM sales
    GROUP BY customer_id
)

SELECT
    fs.sale_date,
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    CONCAT(e.first_name, ' ', e.last_name) AS seller
FROM sales AS s
INNER JOIN customers AS c
    ON s.customer_id = c.customer_id
INNER JOIN products AS p
    ON s.product_id = p.product_id
INNER JOIN employees AS e
    ON s.sales_person_id = e.employee_id
INNER JOIN first_sales AS fs
    ON
        s.customer_id = fs.customer_id
        AND s.sale_date = fs.sale_date
WHERE p.price = 0
GROUP BY
    c.first_name, c.last_name,
    fs.sale_date,
    e.first_name, e.last_name,
    s.customer_id
ORDER BY s.customer_id;
