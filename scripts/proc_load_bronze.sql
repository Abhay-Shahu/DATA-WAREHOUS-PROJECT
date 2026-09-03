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

EXEC bronze.load_bronze;
GO
CREATE OR ALTER PROCEDURE bronze.load_bronze As
BEGIN
	DECLARE @starttime DATETIME,@endtime DATETIME,@batch_starttime DATETIME,@batch_endtime DATETIME;
	SET @batch_starttime=GetDATE();
	BEGIN TRY
		PRINT'==========================================';
		PRINT 'Loading Bronze Layer';
		PRINT'==========================================';
		PRINT'------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT'------------------------------------------';

		SET @starttime =GetDATE();

		PRINT'>>Truncating Table : bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT'>>Inserting into : bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM'C:\Users\abhay\Desktop\SQL-Data-WareHouse\source_crm\cust_info.csv'
		WITH(
			FIRSTROW =2,
			FIELDTERMINATOR =',',
			TABLOCK
		);

		SET @endtime =GETDATE();
		PRINT'>>LOAD DURATION :'+CAST(DATEDIFF(second,@starttime,@endtime) AS NVARCHAR)+' seconds';
		PRINT'-----------------';
		SET @starttime =GetDATE();
		PRINT'>>Truncating Table : bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT'>>Inserting into : bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM'C:\Users\abhay\Desktop\SQL-Data-WareHouse\source_crm\prd_info.csv'
		WITH(
			FIRSTROW =2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @endtime =GETDATE();
		PRINT'>>LOAD DURATION :'+CAST(DATEDIFF(second,@starttime,@endtime) AS NVARCHAR)+' seconds';
		PRINT'-----------------';
		PRINT'>>Truncating Table : bronze.crm_sales_details';
		SET @starttime =GetDATE();
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT'>>Inserting into : bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM'C:\Users\abhay\Desktop\SQL-Data-WareHouse\source_crm\sales_details.csv'
		WITH(
			FIRSTROW =2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @endtime =GETDATE();
		PRINT'>>LOAD DURATION :'+CAST(DATEDIFF(second,@starttime,@endtime) AS NVARCHAR)+' seconds';
		PRINT'-----------------';
		PRINT'------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT'------------------------------------------';
		SET @starttime =GetDATE();
		PRINT'>>Truncating Table : bronze.bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT'>>Inserting into : bronze.bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM'C:\Users\abhay\Desktop\SQL-Data-WareHouse\source_erp\loc_a101.csv'
		WITH(
			FIRSTROW =2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @endtime =GETDATE();
		PRINT'>>LOAD DURATION :'+CAST(DATEDIFF(second,@starttime,@endtime) AS NVARCHAR)+' seconds';
		PRINT'-----------------';
		PRINT'>>Truncating Table : bronze.bronze.erp_cust_az12';
		SET @starttime =GetDATE();
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT'>>Inserting into : bronze.bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM'C:\Users\abhay\Desktop\SQL-Data-WareHouse\source_erp\cust_az12.csv'
		WITH(
			FIRSTROW =2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @endtime =GETDATE();
		PRINT'>>LOAD DURATION :'+CAST(DATEDIFF(second,@starttime,@endtime) AS NVARCHAR)+' seconds';
	    PRINT'-----------------';
		PRINT'>>Truncating Table : bronze.bronze.erp_px_cat_g1v2';
		SET @starttime =GetDATE();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT'>>Inserting into : bronze.bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM'C:\Users\abhay\Desktop\SQL-Data-WareHouse\source_erp\px_cat_g1v2.csv'
		WITH(
			FIRSTROW =2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @endtime =GETDATE();
		PRINT'>>LOAD DURATION :'+CAST(DATEDIFF(second,@starttime,@endtime) AS NVARCHAR)+' seconds';
		PRINT'-----------------';
		SET @batch_endtime =GETDATE();
		PRINT'=======================================';
		PRINT'Loding In Bronze Layer Is Completed';
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
