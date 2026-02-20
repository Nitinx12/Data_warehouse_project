SELECT
	EXTRACT(YEAR FROM S.order_date) AS order_year,
	EXTRACT(MONTH FROM S.order_date) AS order_month,
	SUM(S.sales) AS total_sales,
	COUNT(DISTINCT S.order_number) AS total_orders,
	SUM(S.quantity) AS total_quantity
FROM gold.fact_sales AS S
WHERE S.order_date IS NOT NULL
GROUP BY
	EXTRACT(YEAR FROM S.order_date),
	EXTRACT(MONTH FROM S.order_date)
ORDER BY
	EXTRACT(YEAR FROM S.order_date),
	EXTRACT(MONTH FROM S.order_date)
