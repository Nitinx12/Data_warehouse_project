WITH Cohort_items AS(
	SELECT
		customer_key,
		DATE_TRUNC('MONTH',MIN(order_date)) :: DATE AS cohort_months
	FROM gold.fact_sales
	GROUP BY
		customer_key
),
March_cohort AS(
	SELECT
		customer_key,
		cohort_months
	FROM Cohort_items
	WHERE cohort_months = '2013-03-01'
),
Index_table AS(
	SELECT
		F.customer_key,
		M.cohort_months,
		DATE_TRUNC('MONTH',F.order_date :: DATE) :: DATE AS activity_months,
		(
		EXTRACT(YEAR FROM F.order_date) * 12 +
		EXTRACT(MONTH FROM F.order_date)
		) -
		(
		EXTRACT(YEAR FROM M.cohort_months) * 12 +
		EXTRACT(MONTH FROM M.cohort_months)
		) AS index_number,
		SUM(F.sales) AS revenue
	FROM March_cohort AS M
	INNER JOIN gold.fact_sales AS F ON
	M.customer_key = F.customer_key
	GROUP BY
		F.customer_key,
		M.cohort_months,
		DATE_TRUNC('MONTH',F.order_date :: DATE),
		index_number
),
Cohort_summary AS(
	SELECT
		cohort_months,
		index_number,
		COUNT(DISTINCT customer_key) AS active_customers,
		SUM(revenue) AS total_revenue
	FROM Index_table
	WHERE index_number BETWEEN 0 AND 5
	GROUP BY
		cohort_months,
		index_number
),
Calander_index AS(
	SELECT Generate_series(0,5) AS index_number
),
Base_cohort AS(
	SELECT
		COUNT(DISTINCT customer_key) AS base_size
	FROM March_cohort
)
SELECT
	'2013-03-01' :: DATE AS cohort_month,
	C.index_number,
	COALESCE(CS.active_customers) AS active_customers,
	B.base_size,
	COALESCE(CS.active_customers,0) * 100 / B.base_size AS retention_pct,
	COALESCE(CS.total_revenue,0) AS total_revenue
FROM Calander_index AS C
CROSS JOIN Base_cohort AS B
LEFT JOIN Cohort_summary AS CS ON
C.index_number = CS.index_number
ORDER BY
	index_number
