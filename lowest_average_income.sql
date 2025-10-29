-- Формирование отчета о выявлении продавцов с выручкой ниже средней.
WITH
  each_avg AS (
    SELECT
      e.first_name,
      e.last_name,
      FLOOR(SUM(s.quantity * p.price) / COUNT(*)) AS average_income -- средняя выручка по каждому продавцу
    FROM
      employees e
      INNER JOIN sales s ON s.sales_person_id = e.employee_id
      INNER JOIN products p ON p.product_id = s.product_id
    GROUP BY
      e.first_name,
      e.last_name
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
