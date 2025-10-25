-- Определение десяти продавцов с наибольшей выручкой. 
SELECT 
  CONCAT(c.first_name, ' ', c.last_name) AS seller,
  COUNT(s.sales_person_id) AS operations,
  FLOOR(SUM(s.quantity * p.price)) AS income
FROM
  customers c
  INNER JOIN sales s ON c.customer_id = s.customer_id
  INNER JOIN products p ON p.product_id = s.product_id
GROUP BY
  CONCAT(c.first_name, ' ', c.last_name)
ORDER BY
  income DESC
LIMIT
  10;
