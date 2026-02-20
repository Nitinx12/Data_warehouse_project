/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER()
		OVER(ORDER BY CI.cst_id) AS customer_key,
	CI.cst_id AS customer_id,
	CI.cst_key AS customer_number,
	CI.cst_first_name AS first_name,
	CI.cst_last_name AS last_name,
	LA.cntry AS country,
	CI.cst_marital_status AS marital_status,
	CASE
		WHEN CI.cst_gndr <> 'N/A' THEN CI.cst_gndr
		ELSE COALESCE(CA.gen, 'N/A')
	END AS gender,
	CA.bdate AS birth_date,
	CI.cst_create_date
FROM silver.crm_cust_info AS CI
LEFT JOIN silver.erp_cust_az12 AS CA
ON CI.cst_key = CA.cid
LEFT JOIN silver.erp_loc_a101 AS LA
ON CI.cst_key = LA.cid

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER()
		OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcate AS sub_category,
	pc.maintenance AS maintenance,
	pn.prd_cost AS product_cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pc.id = pn.cat_id
WHERE pn.prd_end_dt IS NULL

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
CREATE VIEW gold.fact_sales AS 
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_date AS ship_date,
	sd.sls_due_date AS due_date,
	sd.sls_sales AS sales,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products AS pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers AS cu
ON sd.sls_cust_id = cu.customer_id
