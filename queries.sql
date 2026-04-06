-- Подсчёт общего количества покупателей из таблицы customers.
SELECT COUNT(customer_id) AS customers_count
FROM
    customers;


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


-- Формирование отчета о выявлении продавцов с выручкой ниже средней.
WITH
each_avg AS (
    SELECT
        e.first_name,
        e.last_name,
        FLOOR(AVG(s.quantity * p.price)) AS average_income
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
    ea.average_income,
    CONCAT(ea.first_name, ' ', ea.last_name) AS seller
FROM
    each_avg AS ea
CROSS JOIN total_avg AS ta
WHERE
    ta.t_avg > ea.average_income
ORDER BY
    ea.average_income ASC;


-- Формирование отчета о выручке продавцов по дням недели.
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS seller,
    TO_CHAR(s.sale_date, 'day') AS day_of_week,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM sales AS s
INNER JOIN employees AS e ON s.sales_person_id = e.employee_id
INNER JOIN products AS p ON s.product_id = p.product_id
GROUP BY
    seller,
    day_of_week
ORDER BY
    EXTRACT(ISODOW FROM s.sale_date),
    seller;


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


-- Отчёт о покупателях, чья первая покупка пришлась в день специальных акций.
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
