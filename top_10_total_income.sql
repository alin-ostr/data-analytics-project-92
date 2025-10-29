-- Отчёт об определении десяти продавцов с наибольшей выручкой.
SELECT 
  CONCAT(e.first_name, ' ', e.last_name) AS seller,
  COUNT(s.sales_person_id) AS operations,
  FLOOR(SUM(s.quantity * p.price)) AS income
FROM
  employees e
  INNER JOIN sales s ON s.sales_person_id = e.employee_id
  INNER JOIN products p ON p.product_id = s.product_id
GROUP BY
  CONCAT(e.first_name, ' ', e.last_name)
ORDER BY
  income DESC
LIMIT
  10;
