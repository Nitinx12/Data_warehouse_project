SELECT
	category,
	total_sales,
	SUM(total_sales) OVER() AS overall_sales,
	ROUND(total_sales / SUM(total_sales) OVER() * 100,2) AS pct
FROM(
	SELECT
		P.category,
		SUM(S.sales) AS total_sales
	FROM gold.dim_products AS P
	INNER JOIN gold.fact_sales AS S
	ON P.product_key = S.product_key
	GROUP BY
		P.category) AS X
ORDER BY 4 DESC
	
