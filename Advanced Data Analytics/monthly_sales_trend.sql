WITH Monthly_sales AS(
	SELECT
		TO_CHAR(F.order_date, 'YYYY-MM') AS sales_month,
		P.category,
		COUNT(DISTINCT F.order_number) AS total_orders,
		SUM(F.quantity) AS total_units_sold,
		SUM(F.sales) AS total_revenue
	FROM gold.fact_sales AS F
	LEFT JOIN gold.dim_products AS P
	ON F.product_key = P.product_key
	WHERE EXTRACT(YEAR FROM F.order_date) = 2013
	GROUP BY
		TO_CHAR(F.order_date, 'YYYY-MM'),
		P.category
),
Growth AS(
	SELECT
		sales_month,
		category,
		total_orders,
		total_units_sold,
		total_revenue,
		LAG(total_revenue)
			OVER(PARTITION BY category
			ORDER BY sales_month) AS previous_month_revenue
	FROM Monthly_sales	
)
SELECT
	sales_month,
	category,
	total_orders,
	total_units_sold,
	total_revenue,
	COALESCE(previous_month_revenue,0) AS previous_month_revenue,
	CASE
		WHEN previous_month_revenue IS NULL
		THEN 0
		ELSE ROUND((total_revenue - previous_month_revenue) / previous_month_revenue * 100,2)
	END AS mom_growth_percent
FROM Growth
