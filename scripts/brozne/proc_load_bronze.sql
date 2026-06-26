/* 
======================================================================
Stored Procedure: Loading Bronze Layer (source -> Bronze)
======================================================================
Script Purpose: 
	This stored procedure loads data into the 'bronze' schema from external CSV file. 
	It performs the following actions:
	- Truncates the bronze table before loading data. 
	- Uses the 'BULK INSERT' command to loading data from CSV File to bronze table. 

Parameters: 
	None. 
   This stored procedure does not accept any parameters or return any values. 

Usage Example:
	EXEC bronze.load_bronze;
======================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY 

		SET @batch_start_time=GETDATE();
		PRINT'=========================================================';
		PRINT'                   Loading Bronze Layer';
		PRINT'=========================================================';

		SET @start_time=GETDATE();
		PRINT'>>> Truncating Table: bronze.Superstore_sales';
		TRUNCATE TABLE  bronze.Superstore_sales;

		PRINT'>>> Insert Data Into: bronze.Superstore_sales';
		BULK INSERT bronze.Superstore_sales
		FROM 'C:\Users\tejaa\Downloads\archive\Superstore_sales.csv'
		WITH(
		FIRSTROW=2, 
		FIELDTERMINATOR=',', 
		ROWTERMINATOR='0x0a',
		CODEPAGE='65001',
		FORMAT='CSV'
		);  
		SET @end_time=GETDATE(); 
		PRINT'Load Duraction '+CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR)+' seconds';
		PRINT'------------------------'; 
		
		SET @batch_end_time=GETDATE(); 
		PRINT'=========================================================';
		PRINT'LOADIND BRONZE LAYER COMPLETED';
		PRINT'=========================================================';
		PRINT'Load Duraction '+CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR)+' seconds';
		PRINT'------------------------'; 
	END TRY 
	BEGIN CATCH  
		PRINT'=========================================================';
		PRINT'          ERROR OCCURED LOADING BRONZE LAYER'; 
		PRINT'ERROR MESSAGE'+ERROR_MESSAGE(); 
		PRINT'ERROR NUMBER'+CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'ERROR LINE'+CAST(ERROR_LINE() AS NVARCHAR); 
		PRINT'ERROR STATE'+CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'=========================================================';
	END CATCH 
END; 

