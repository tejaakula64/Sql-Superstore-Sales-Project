

CREATE OR ALTER PROCEDURE silver.load_sales_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY 

		SET @batch_start_time=GETDATE();
		PRINT'=========================================================';
		PRINT'                   Loading Silver Layer';
		PRINT'=========================================================';

		SET @start_time=GETDATE();
		PRINT'>>> Truncating Table: Silver.Superstore_sales';
		TRUNCATE TABLE  Silver.Superstore_sales;

		PRINT'>>> Insert Data Into: Silver.Superstore_sales';
		INSERT INTO silver.Superstore_sales(
            Row_ID, 
            Country_Code, 
            Order_year, 
            Order_ID,
            Order_Date, 
            Ship_Date, 
            Ship_Mode, 
            Customer_ID,
            Customer_Name, 
            Segment, 
            Country, 
            City, 
            State,
            Postal_code, 
            Region, 
            Product_ID, 
            Category,
            Sub_Category, 
            Product_Name, 
            Sales, Quantity,
            Discount, 
            Profit, 
            Unit_Price, 
            Cost, 
            dwh_create_date
        )
        SELECT 
            CAST(Row_ID AS INT),
            SUBSTRING(order_id, 1, 2) AS Country_Code,
            CAST(SUBSTRING(order_id, 4, 4) AS INT) AS Order_year,
            SUBSTRING(order_id, 9, LEN(order_id)) AS Order_ID, 
            CAST(Order_Date AS DATE),
            CAST(Ship_Date AS DATE),
            TRIM(Ship_Mode),
            TRIM(Customer_ID),
            TRIM(Customer_Name),
            TRIM(Segment),
            TRIM(Country),
            TRIM(City),
            TRIM(State),
            TRIM(Postal_code),
            TRIM(Region),
            TRIM(Product_ID),
            TRIM(Category),
            TRIM(Sub_Category),
            TRIM(Product_Name),
            CAST(sales AS DECIMAL(10,2)) AS Sales, 
            CAST(Quantity AS INT),
            ROUND(CAST(discount AS FLOAT) * 100, 0) AS Discount,   
            CAST(profit AS DECIMAL(10,2)) AS Profit,    
            CAST(
                CAST(sales AS FLOAT) /NULLIF(CAST(quantity AS FLOAT) * (1 - CAST(discount AS FLOAT)), 0)
            AS DECIMAL(10,2))AS Unit_Price,
            CAST(
            CAST(sales AS DECIMAL(10,2)) - CAST(profit AS DECIMAL(10,2)) 
            AS DECIMAL(10,2))AS Cost,
            GETDATE() AS dwh_create_date 
        FROM (
            SELECT *,
                ROW_NUMBER() OVER(
                    PARTITION BY order_id, sub_category 
                    ORDER BY row_id
                ) AS flag
            FROM bronze.Superstore_sales
        ) AS t
        WHERE flag = 1; 

		SET @end_time=GETDATE(); 
		PRINT'Load Duraction '+CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR)+' seconds';
		PRINT'------------------------'; 
		
		SET @batch_end_time=GETDATE(); 
		PRINT'=========================================================';
		PRINT'LOADIND SILVER LAYER COMPLETED';
		PRINT'=========================================================';
		PRINT'Load Duraction '+CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR)+' seconds';
		PRINT'------------------------'; 
	END TRY 
	BEGIN CATCH  
		PRINT'=========================================================';
		PRINT'          ERROR OCCURED LOADING SILVER LAYER'; 
		PRINT'ERROR MESSAGE'+ERROR_MESSAGE(); 
		PRINT'ERROR NUMBER'+CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'ERROR LINE'+CAST(ERROR_LINE() AS NVARCHAR); 
		PRINT'ERROR STATE'+CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'=========================================================';
	END CATCH 
END;  

