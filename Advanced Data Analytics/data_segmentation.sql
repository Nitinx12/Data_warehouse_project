WITH product_segment AS(
	SELECT
		product_key,
		product_name,
		product_cost,
		CASE
			WHEN product_cost < 100 THEN 'Below 100'
			WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products 	
)
SELECT
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segment
GROUP BY
	cost_range
ORDER BY 
	total_products DESC

==============================================================================

WITH customer_spending AS(
	SELECT
		C.customer_key,
		SUM(S.sales) AS total_spending,
		MIN(S.order_date) AS first_order,
		MAX(S.order_date) AS last_order,
		EXTRACT(YEAR FROM AGE(MAX(S.order_date), MIN(S.order_date))) * 12
	    + EXTRACT(MONTH FROM AGE(MAX(S.order_date), MIN(S.order_date)))
	    AS month_span
	FROM gold.fact_sales AS S
	LEFT JOIN gold.dim_customers AS C
	ON S.customer_key = C.customer_key
	GROUP BY
		C.customer_key
)
SELECT
	CASE
		WHEN month_span >= 12 AND total_spending > 5000
		THEN 'VIP'
		WHEN month_span >= 12 AND total_spending <= 5000
		THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	COUNT(customer_key) AS total_customers
FROM customer_spending
GROUP BY
	customer_segment


















































