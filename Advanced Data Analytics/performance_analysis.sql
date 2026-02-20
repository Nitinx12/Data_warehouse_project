SELECT
	order_year,
	product_name,
	current_sales,
	ROUND(AVG(current_sales) 
		OVER(PARTITION BY product_name),2) AS avg_sales,
	ROUND(current_sales - AVG(current_sales) 
						OVER(PARTITION BY product_name),2) AS diff_avg,
	CASE
		WHEN current_sales - AVG(current_sales) 
						OVER(PARTITION BY product_name) > 0
						THEN 'Above Average'
		WHEN current_sales - AVG(current_sales) 
						OVER(PARTITION BY product_name) < 0
						THEN 'Below Average'
		ELSE 'Average'
	END AS avg_change,
	LAG(current_sales)
		OVER(PARTITION BY product_name) AS py_sales,
	CASE
		WHEN current_sales - LAG(current_sales)
								OVER(PARTITION BY product_name) > 0
								THEN 'Increase'
		WHEN current_sales - LAG(current_sales)
								OVER(PARTITION BY product_name) < 0
								THEN 'Decrease'
		ELSE 'No change'
	END AS py_changes								
FROM(SELECT
		EXTRACT(YEAR FROM S.order_date) AS order_year,
		P.product_name,
		SUM(S.sales) AS current_sales
	FROM gold.fact_sales AS S
	LEFT JOIN gold.dim_products AS P
	ON S.product_key = P.product_key
	WHERE S.order_date IS NOT NULL
	GROUP BY
		EXTRACT(YEAR FROM S.order_date),
		P.product_name) AS X
	
