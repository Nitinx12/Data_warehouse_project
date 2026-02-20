/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CALL silver.load_silver_layer()

CREATE OR REPLACE PROCEDURE silver.load_silver_layer()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time   TIMESTAMP;
    v_table_start  TIMESTAMP;
    v_table_end    TIMESTAMP;
    v_total_time   INTERVAL;
    v_current_step VARCHAR(100); -- Tracks the current process for error reporting
BEGIN

    v_start_time := clock_timestamp();
    v_current_step := 'Initializing procedure';

    RAISE NOTICE '========== SILVER LAYER LOAD START ==========';

    ----------------------------------------------------------------
    -- 1. CRM CUSTOMER INFO
    ----------------------------------------------------------------
    v_current_step := 'Loading silver.crm_cust_info';
    v_table_start := clock_timestamp();

    RAISE NOTICE '>> %', v_current_step;

    TRUNCATE TABLE silver.crm_cust_info;

    INSERT INTO silver.crm_cust_info(
        cst_id,
        cst_key,
        cst_first_name,
        cst_last_name,
        cst_marital_status,
        cst_gndr,
        cst_create_date
    )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_first_name),
        TRIM(cst_last_name),
        CASE
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            ELSE 'N/A'
        END,
        CASE
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'N/A'
        END,
        cst_create_date::DATE
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY cst_id
                   ORDER BY cst_create_date DESC
               ) rnk
        FROM bronze.crm_cust_info
    ) X
    WHERE rnk = 1;

    v_table_end := clock_timestamp();
    RAISE NOTICE '   Time: %', v_table_end - v_table_start;

    ----------------------------------------------------------------
    -- 2. CRM PRODUCT INFO
    ----------------------------------------------------------------
    v_current_step := 'Loading silver.crm_prd_info';
    v_table_start := clock_timestamp();

    RAISE NOTICE '>> %', v_current_step;

    TRUNCATE TABLE silver.crm_prd_info;

    INSERT INTO silver.crm_prd_info(
        prd_id,
        prd_key,
        cat_id,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT
        prd_id,
        SUBSTRING(prd_key FROM 7),
        REPLACE(SUBSTRING(prd_key FROM 1 FOR 5), '-', '_'),
        prd_nm,
        COALESCE(prd_cost,0),
        CASE
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'N/A'
        END,
        prd_start_dt::DATE,
        CAST(
            LEAD(prd_start_dt)
            OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1
            AS DATE
        )
    FROM bronze.crm_prd_info;

    v_table_end := clock_timestamp();
    RAISE NOTICE '   Time: %', v_table_end - v_table_start;

    ----------------------------------------------------------------
    -- 3. CRM SALES DETAILS
    ----------------------------------------------------------------
    v_current_step := 'Loading silver.crm_sales_details';
    v_table_start := clock_timestamp();

    RAISE NOTICE '>> %', v_current_step;

    TRUNCATE TABLE silver.crm_sales_details;

    INSERT INTO silver.crm_sales_details(
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_date,
        sls_due_date,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE
            WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) <> 8
            THEN NULL
            ELSE TO_DATE(sls_order_dt::TEXT,'YYYYMMDD')
        END,
        CASE
            WHEN sls_ship_date = 0 OR LENGTH(sls_ship_date::TEXT) <> 8
            THEN NULL
            ELSE TO_DATE(sls_ship_date::TEXT,'YYYYMMDD')
        END,
        CASE
            WHEN sls_due_date = 0 OR LENGTH(sls_due_date::TEXT) <> 8
            THEN NULL
            ELSE TO_DATE(sls_due_date::TEXT,'YYYYMMDD')
        END,
        CASE
            WHEN sls_price IS NULL OR sls_sales <= 0
                 OR sls_sales <> sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END,
        sls_quantity,
        CASE
            WHEN sls_price IS NULL OR sls_price <= 0
            THEN sls_price / NULLIF(sls_quantity,0)
            ELSE sls_price
        END
    FROM bronze.crm_sales_details;

    v_table_end := clock_timestamp();
    RAISE NOTICE '   Time: %', v_table_end - v_table_start;

    ----------------------------------------------------------------
    -- 4. ERP CUSTOMER AZ12
    ----------------------------------------------------------------
    v_current_step := 'Loading silver.erp_cust_az12';
    v_table_start := clock_timestamp();

    RAISE NOTICE '>> %', v_current_step;

    TRUNCATE TABLE silver.erp_cust_az12;
    
    INSERT INTO silver.erp_cust_az12(
        cid,
        bdate,
        gen
    )
    SELECT
        CASE
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid FROM 4)
            ELSE cid
        END AS cid,
        CASE
            WHEN bdate > CURRENT_DATE THEN NULL
            ELSE bdate
        END AS bdate,
        CASE
            WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
            ELSE 'N/A'
        END AS gen
    FROM bronze.erp_cust_az12;

    v_table_end := clock_timestamp();
    RAISE NOTICE '   Time: %', v_table_end - v_table_start;

    ----------------------------------------------------------------
    -- 5. ERP LOCATION A101
    ----------------------------------------------------------------
    v_current_step := 'Loading silver.erp_loc_a101';
    v_table_start := clock_timestamp();

    RAISE NOTICE '>> %', v_current_step;

    TRUNCATE TABLE silver.erp_loc_a101;
    
    INSERT INTO silver.erp_loc_a101(
        cid,
        cntry
    )
    SELECT
        REPLACE(cid,'-','') AS cid,
        CASE
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
            ELSE TRIM(cntry)
        END AS cntry
    FROM bronze.erp_loc_a101;

    v_table_end := clock_timestamp();
    RAISE NOTICE '   Time: %', v_table_end - v_table_start;

    ----------------------------------------------------------------
    -- 6. ERP PX CATEGORY G1V2
    ----------------------------------------------------------------
    v_current_step := 'Loading silver.erp_px_cat_g1v2';
    v_table_start := clock_timestamp();

    RAISE NOTICE '>> %', v_current_step;

    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    
    INSERT INTO silver.erp_px_cat_g1v2(
        id,
        cat,
        subcate,
        maintenance
    )
    SELECT
        id,
        cat,
        subcat,
        maintenance
    FROM bronze.erp_px_cat_g1v2;    

    v_table_end := clock_timestamp();
    RAISE NOTICE '   Time: %', v_table_end - v_table_start;

    ----------------------------------------------------------------
    -- TOTAL TIME
    ----------------------------------------------------------------
    v_current_step := 'Finalizing load';
    v_total_time := clock_timestamp() - v_start_time;

    RAISE NOTICE '========== LOAD COMPLETE ==========';    
    RAISE NOTICE 'Total Load Time: %', v_total_time;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '========== ERROR DURING LOAD ==========';
        RAISE NOTICE 'Failed Step: %', v_current_step;
        RAISE NOTICE 'Error Code: %', SQLSTATE;
        RAISE NOTICE 'Error Message: %', SQLERRM;
        
        -- Re-raise the exception to abort the transaction entirely
        RAISE EXCEPTION 'Silver layer load failed during step: %. Check logs for details. Error: %', v_current_step, SQLERRM;
END;
$$;
