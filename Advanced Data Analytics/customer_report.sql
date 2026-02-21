CREATE VIEW gold.customer_report AS
WITH Base_query AS(
	SELECT
		F.order_number,
		F.product_key,
		F.order_date,
		F.sales,
		F.quantity,
		C.customer_key,
		C.customer_number,
		CONCAT(C.first_name,' ',C.last_name) AS customer_name,
		EXTRACT(YEAR FROM AGE(C.birth_date)) AS age
	FROM gold.fact_sales AS F
	LEFT JOIN gold.dim_customers AS C
	ON C.customer_key = F.customer_key
	WHERE F.order_date IS NOT NULL
),
Metrics AS(
	SELECT
		customer_key,
		customer_number,
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order_date,
		MIN(order_date) AS first_order_date,
		EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
   	 	EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan_months
	FROM Base_query
	GROUP BY
		customer_key,
		customer_number,
		customer_name,
		age		
)
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE
		WHEN age < 20
		THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29
		THEN '20-29'
		WHEN age BETWEEN 30 AND 39
		THEN '30-39'
		WHEN age BETWEEN 40 AND 49
		THEN '40-49'
		ELSE '50 and above'
	END AS age_group,	
	CASE
		WHEN lifespan_months >= 12 AND total_sales > 5000
		THEN 'VIP'
		WHEN lifespan_months >= 12 AND total_sales <= 5000
		THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order_date,
	CURRENT_DATE - last_order_date AS recency,
	first_order_date,
	lifespan_months,
	CASE
		WHEN total_orders = 0
		THEN 0
		ELSE ROUND(total_sales / total_orders,2)
	END AS avg_order_value,
	CASE
		WHEN lifespan_months = 0
		THEN total_sales
		ELSE ROUND(total_sales / lifespan_months,2)
	END AS avg_monthly_spend
FROM Metrics













































