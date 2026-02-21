CREATE VIEW gold.report_products AS
WITH Base_query AS(
	SELECT
		F.order_number,
		F.order_date,
		F.customer_key,
		F.sales,
		F.quantity,
		P.product_key,
		P.product_name,
		P.category,
		P.sub_category,
		P.product_cost
	FROM gold.fact_sales AS F
	LEFT JOIN gold.dim_products AS P
	ON F.product_key = P.product_key
	WHERE F.order_date IS NOT NULL
),
Metrics AS(
	SELECT
		product_key,
		product_name,
		category,
		sub_category,
		product_cost,
		EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
	   	EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan_months,
		MAX(order_date) AS last_sales_date,
		COUNT(DISTINCT order_number) AS total_orders,
		COUNT(DISTINCT customer_key) AS total_customers,
		SUM(sales) AS total_sales,
		SUM(quantity) AS total_quantity,
		AVG(product_cost) AS avg_selling_price
	FROM Base_query
	GROUP BY
		product_key,
		product_name,
		category,
		sub_category,
		product_cost
)
SELECT
	product_key,
	product_name,
	category,
	sub_category,
	product_cost,
	last_sales_date,
	CURRENT_DATE - last_sales_date AS recency,
	CASE
		WHEN total_sales > 50000 THEN 'High performer'
		WHEN total_sales >= 10000 THEN 'Mid range'
		ELSE 'Low performer'
	END AS product_segment,
	lifespan_months,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	ROUND(avg_selling_price,2) AS avg_selling_price,
	CASE
		WHEN total_orders = 0
		THEN 0
		ELSE ROUND(total_sales / total_orders,2)
	END AS avg_order_revenue,
	CASE
		WHEN lifespan_months = 0
		THEN total_sales
		ELSE ROUND(total_sales / lifespan_months,2)
	END AS avg_monthly_revenue
FROM Metrics
	
	

















































