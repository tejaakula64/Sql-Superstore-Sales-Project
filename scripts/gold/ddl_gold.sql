/*
================================================================================
DDL Script: Creating Gold View
================================================================================ 
Script Purpose: 
	This script creates views for the Gold layer in the data warehouse. 
	
	The view performs transformations and combines data from the Silver layer 
	to produce a clean, enriched and business-ready dataset.

Usage: 
	- These views can be queried directly for analytics and reporting.
================================================================================
*/


IF OBJECT_ID('gold.superstore_sales','V') IS NOT NULL
	DROP VIEW gold.superstore_sales; 
GO 

CREATE VIEW gold.superstore_sales AS 
SELECT 
Row_ID          AS row_id,
Order_ID        AS order_id, 
Order_Date      AS order_date, 
Ship_Date       AS ship_date,
Ship_Mode       AS ship_mode, 
Customer_ID     AS customer_id, 
Customer_Name   AS customer_name, 
Segment         AS segment, 
Country         AS country, 
City            AS city_name, 
State           AS state_name,
Postal_code     AS postal_code,
Region          AS region, 
Product_ID      AS product_id, 
Category        AS category, 
Sub_Category    AS sub_category, 
Product_Name    AS product_name,
Sales           AS sales, 
Quantity        AS quantity, 
Discount        AS discount, 
Profit          AS profit, 
Unit_Price      AS unit_price, 
Cost            AS cost, 
dwh_create_date
FROM silver.Superstore_sales; 

