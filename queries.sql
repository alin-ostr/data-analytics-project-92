-- Подсчёт общего количества покупателей из таблицы customers
SELECT
  COUNT(customer_id) AS customers_count
FROM
  customers;
