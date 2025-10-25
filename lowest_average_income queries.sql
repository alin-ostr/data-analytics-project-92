-- Выявление продавцов с выручкой ниже средней
WITH
  each_avg AS (
    SELECT
      c.first_name,
      c.last_name,
      FLOOR(SUM(s.quantity * p.price) / COUNT(*)) AS average_income -- средняя выручка по каждому продавцу
    FROM
      customers c
      INNER JOIN sales s ON c.customer_id = s.customer_id
      INNER JOIN products p ON p.product_id = s.product_id
    GROUP BY
      c.first_name,
      c.last_name
  ),
  total_avg AS (
    SELECT
      AVG(average_income) AS t_avg -- общая стредняя выручка
    FROM
      each_avg
  )
SELECT
  CONCAT(first_name, ' ', last_name) AS seller,
  average_income
FROM
  each_avg
  CROSS JOIN total_avg -- сравнение значений
WHERE
  t_avg > average_income
ORDER BY
  average_income ASC;
