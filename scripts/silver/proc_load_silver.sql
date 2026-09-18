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

CREATE OR ALTER  PROCEDURE silver.silver_load AS
BEGIN
DECLARE @starttime DATETIME ,@endtime DATETIME ,@batch_starttime DATETIME,@batch_endtime DATETIME;
SET @batch_starttime =GETDATE();
BEGIN TRY
		PRINT'==========================================';
		PRINT 'Loading Silver Layer';
		PRINT'==========================================';
		PRINT'------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT'------------------------------------------';
SET @starttime =GETDATE();
PRINT'>>Truncating Table : silver.crm_cust_info';
TRUNCATE TABLE silver.crm_cust_info;
PRINT'>>Inserting into : silver.crm_cust_info';
INSERT INTO silver.crm_cust_info(
  cst_id,
  cst_key,
  cst_firstname,
  cst_lastname,
  cst_marital_status,
  cst_gndr,
  cst_create_date
)
SELECT cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
(CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married' 
	  WHEN UPPER(TRIM(cst_marital_status)) ='S'THEN 'Single'
	  ELSE 'n/a'
END)cst_marital_status,
(CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' 
	  WHEN UPPER(TRIM(cst_gndr)) ='F'THEN 'Female'
	  ELSE 'n/a'
END)cst_gndr,
cst_create_date
FROM
(SELECT *,
ROW_NUMBER()OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze.crm_cust_info
)t WHERE  flag_last =1 AND cst_ID IS NOT NULL
	SET @endtime =GETDATE();
	PRINT'>>LOAD DURATION :'+CAST(DATEDIFF(second,@starttime,@endtime) AS NVARCHAR)+' seconds';
	PRINT'-----------------';
	PRINT'>>Truncating Table : silver.crm_prd_info';
	TRUNCATE TABLE silver.crm_prd_info
	PRINT'>>Inserting into : silver.crm_prd_info';
	SET @starttime = GETDATE();
	INSERT INTO silver.crm_prd_info(
	prd_id ,
	cst_id ,
	prd_key ,
	prd_nm ,
	prd_cost,
	prd_line ,
	prd_start_dt ,
	dwh_prd_end_dt 
	)
SELECT prd_id,
	REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cst_id,
	SUBSTRING(prd_key,7,len(prd_key)) AS prd_key,
	prd_nm,
	COALESCE(prd_cost,0) prd_cost,
	CASE UPPER(TRIM(prd_line))
		 WHEN 'R'THEN 'Road'
		 WHEN 'S' THEN 'Other Sales'
		 WHEN 'M' THEN 'Mountain'
		 WHEN 'T' THEN 'Touring' 
		 END AS prd_line ,
		CAST(prd_start_dt AS DATE) prd_start_dt ,
	CAST(
	LEAD(prd_start_dt) 
	OVER(PARTITION BY prd_key ORDER BY prd_start_dt)  AS DATE)
	AS dwh_prd_end_dt
	FROM bronze.crm_prd_info
	SET @endtime = GETDATE();
	PRINT 'LOAD DURATION :'+CAST(DATEDIFF(second,@starttime,@endtime)AS NVARCHAR)+'seconds';
	PRINT'-----------------';
	PRINT'>>Truncating Table : silver.crm_sales_details';
TRUNCATE TABLE silver.crm_sales_details
PRINT'>>Inserting into : silver.crm_sales_details';
SET @starttime =GETDATE();
INSERT INTO silver.crm_sales_details  (
    sls_ord_num ,
	sls_prd_key ,
	sls_cust_id ,
	sls_order_dt ,
	sls_ship_dt ,
	sls_due_dt ,
	sls_sales ,
	sls_quantity,
	sls_price )
SELECT 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE 
    WHEN sls_order_dt = 0 OR LEN(sls_order_dt)!=8 THEN NULL
    ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
    END as sls_order_dt,
    CASE 
        WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt)!=8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END as sls_ship_dt,
    CASE 
        WHEN sls_due_dt = 0 OR LEN(sls_due_dt)!=8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END as sls_due_dt,
    CASE 
        WHEN sls_sales IS NULL OR sls_sales<=0 OR sls_sales != sls_quantity * ABS(sls_price) 
        THEN sls_quantity*ABS(sls_price)
        ELSE sls_sales
        END AS sls_sales ,
         sls_quantity,
    CASE 
        WHEN sls_price IS NULL OR sls_price<=0
        THEN sls_sales / NULLIF(sls_quantity,0)
        ELSE sls_price
        END AS sls_price
  FROM bronze.crm_sales_details;
	SET @endtime =GETDATE();
	PRINT 'LOAD DURATION :'+CAST(DATEDIFF(second,@starttime,@endtime)AS NVARCHAR)+'seconds';
	PRINT'-----------------';
    PRINT'------------------------------------------';
	PRINT 'Loading CRM Tables';
	PRINT'------------------------------------------';
	SET @starttime =GetDATE();
	PRINT'------------------------------------------';
	PRINT 'Loading ERP Tables';
	PRINT'------------------------------------------'
	PRINT'>>Truncating Table : silver.erp_loc_a101';
TRUNCATE TABLE silver.erp_loc_a101
	PRINT'>>Iserting into : silver.erp_loc_a101';
INSERT INTO silver.erp_loc_a101(cid,cntry)
SELECT
REPLACE(cid,'-','') AS cid,
CASE 
	WHEN UPPER(TRIM(cntry))='DE'THEN 'Germany'
	WHEN UPPER(TRIM(cntry)) IN('US','USA') THEN 'United States'
	WHEN TRIM(cntry) = ''OR cntry IS NULL THEN 'nan'
	ELSE cntry
END AS cntry
FROM bronze.erp_loc_a101;
	SET @endtime =GETDATE();
	PRINT 'LOAD DURATION :'+CAST(DATEDIFF(second,@starttime,@endtime)AS NVARCHAR)+'seconds';
	PRINT'-----------------';
	PRINT'>>Truncating Table : silver.erp_cust_az12';
	SET @starttime =GetDATE();
TRUNCATE TABLE silver.erp_cust_az12
	PRINT'>>Inserting into: silver.erp_cust_az12';
INSERT INTO silver.erp_cust_az12(
 cid,
 bdate,
 gen
 )
SELECT 
CASE WHEN cid LIKE 'NAS%'
THEN SUBSTRING(cid,4,len(cid))
ELSE cid
end AS cid ,
CASE 
    WHEN bdate <'1926-01-01' OR bdate > GETDATE() THEN NULL 
ELSE bdate 
END AS bdate,
CASE 
  WHEN UPPER(TRIM(gen)) IN('M','MALE')THEN 'Male'
  WHEN UPPER(TRIM(gen))IN ('F','FEMALE')THEN 'Female'
ELSE 'nan' 
  END AS gen 
FROM bronze.erp_cust_az12;
	SET @endtime =GETDATE();
	PRINT 'LOAD DURATION :'+CAST(DATEDIFF(second,@starttime,@endtime)AS NVARCHAR)+'seconds';
	PRINT'-----------------';
	PRINT'>>Truncating Table : silver.erp_px_cat_g1v2';
	SET @starttime =GetDATE();
TRUNCATE TABLE silver.erp_px_cat_g1v2
	PRINT'>>Inserting intoTruncating Table : silver.erp_px_cat_g1v2';
INSERT INTO silver.erp_px_cat_g1v2(
id,
cat,
subcat,
maintenance)
SELECT 
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2;
	SET @endtime =GETDATE();
	PRINT 'LOAD DURATION :'+CAST(DATEDIFF(second,@starttime,@endtime)AS NVARCHAR)+' seconds';
	PRINT'-----------------';
	PRINT'------------------------------------------';
	PRINT 'Loading ERP Tables';
	PRINT'------------------------------------------';
	SET @batch_endtime =GETDATE();
		PRINT'=======================================';
		PRINT'Loding In Silver Layer Is Completed';
		PRINT'>> TOTAL LOAD DURATION   :'+CAST(DATEDIFF(second,@batch_starttime,@batch_endtime) AS NVARCHAR)+' seconds';
		PRINT'=======================================';
	END TRY
	BEGIN CATCH
	PRINT'=========================================';
	PRINT'Error Occured During Lodaing Bronze Layer';
	PRINT'Error Message'+CAST(ERROR_MESSAGE() AS NVARCHAR);
	PRINT'Error Occured'+CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT'=========================================';
	END CATCH
	END
