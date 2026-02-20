SELECT 
	order_date,
	total_sales,
	SUM(total_sales) 
		OVER(ORDER BY order_date) AS running_total_sales,
	ROUND(AVG(avg_price)
		OVER(ORDER BY order_date),2) AS moving_avg_price
FROM(SELECT
		order_date,
		SUM(sales) AS total_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY
		order_date) AS X
