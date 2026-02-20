/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/


CALL bronze.load_bronze()

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time   TIMESTAMP;
    v_duration   INTERVAL;
    v_table_name TEXT;
BEGIN

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';

    ------------------------------------------------
    -- CRM TABLES
    ------------------------------------------------
    RAISE NOTICE 'Loading CRM Tables';

    -- crm_cust_info
    v_table_name := 'bronze.crm_cust_info';
    v_start_time := clock_timestamp();
    RAISE NOTICE '>> Loading % | Start: %', v_table_name, v_start_time;

    TRUNCATE TABLE bronze.crm_cust_info;
    COPY bronze.crm_cust_info
    FROM 'C:\Users\91852\Downloads\Datawarehouse\datasets\source_crm\cust_info.csv'
    DELIMITER ','
    CSV HEADER;

    v_end_time := clock_timestamp();
    v_duration := v_end_time - v_start_time;

    RAISE NOTICE '<< Completed % | End: % | Duration: %',
                 v_table_name, v_end_time, v_duration;


    -- crm_prd_info
    v_table_name := 'bronze.crm_prd_info';
    v_start_time := clock_timestamp();
    RAISE NOTICE '>> Loading % | Start: %', v_table_name, v_start_time;

    TRUNCATE TABLE bronze.crm_prd_info;
    COPY bronze.crm_prd_info
    FROM 'C:\Users\91852\Downloads\Datawarehouse\datasets\source_crm\prd_info.csv'
    DELIMITER ','
    CSV HEADER;

    v_end_time := clock_timestamp();
    v_duration := v_end_time - v_start_time;

    RAISE NOTICE '<< Completed % | End: % | Duration: %',
                 v_table_name, v_end_time, v_duration;


    -- crm_sales_details
    v_table_name := 'bronze.crm_sales_details';
    v_start_time := clock_timestamp();
    RAISE NOTICE '>> Loading % | Start: %', v_table_name, v_start_time;

    TRUNCATE TABLE bronze.crm_sales_details;
    COPY bronze.crm_sales_details
    FROM 'C:\Users\91852\Downloads\Datawarehouse\datasets\source_crm\sales_details.csv'
    DELIMITER ','
    CSV HEADER;

    v_end_time := clock_timestamp();
    v_duration := v_end_time - v_start_time;

    RAISE NOTICE '<< Completed % | End: % | Duration: %',
                 v_table_name, v_end_time, v_duration;


    ------------------------------------------------
    -- ERP TABLES
    ------------------------------------------------
    RAISE NOTICE 'Loading ERP Tables';

    -- erp_cust_az12
    v_table_name := 'bronze.erp_cust_az12';
    v_start_time := clock_timestamp();
    RAISE NOTICE '>> Loading % | Start: %', v_table_name, v_start_time;

    TRUNCATE TABLE bronze.erp_cust_az12;
    COPY bronze.erp_cust_az12
    FROM 'C:\Users\91852\Downloads\Datawarehouse\datasets\source_erp\CUST_AZ12.csv'
    DELIMITER ','
    CSV HEADER;

    v_end_time := clock_timestamp();
    v_duration := v_end_time - v_start_time;

    RAISE NOTICE '<< Completed % | End: % | Duration: %',
                 v_table_name, v_end_time, v_duration;


    -- erp_loc_a101
    v_table_name := 'bronze.erp_loc_a101';
    v_start_time := clock_timestamp();
    RAISE NOTICE '>> Loading % | Start: %', v_table_name, v_start_time;

    TRUNCATE TABLE bronze.erp_loc_a101;
    COPY bronze.erp_loc_a101
    FROM 'C:\Users\91852\Downloads\Datawarehouse\datasets\source_erp\LOC_A101.csv'
    DELIMITER ','
    CSV HEADER;

    v_end_time := clock_timestamp();
    v_duration := v_end_time - v_start_time;

    RAISE NOTICE '<< Completed % | End: % | Duration: %',
                 v_table_name, v_end_time, v_duration;


    -- erp_px_cat_g1v2
    v_table_name := 'bronze.erp_px_cat_g1v2';
    v_start_time := clock_timestamp();
    RAISE NOTICE '>> Loading % | Start: %', v_table_name, v_start_time;

    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    COPY bronze.erp_px_cat_g1v2
    FROM 'C:\Users\91852\Downloads\Datawarehouse\datasets\source_erp\PX_CAT_G1V2.CSV'
    DELIMITER ','
    CSV HEADER;

    v_end_time := clock_timestamp();
    v_duration := v_end_time - v_start_time;

    RAISE NOTICE '<< Completed % | End: % | Duration: %',
                 v_table_name, v_end_time, v_duration;


    RAISE NOTICE '================================================';
    RAISE NOTICE 'Bronze Layer Load Completed Successfully';
    RAISE NOTICE '================================================';


EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '================================================';
        RAISE NOTICE 'ERROR DURING BRONZE LOAD';
        RAISE NOTICE 'Failed Table: %', v_table_name;
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE 'Error Code: %', SQLSTATE;
        RAISE NOTICE '================================================';

END;
$$;
