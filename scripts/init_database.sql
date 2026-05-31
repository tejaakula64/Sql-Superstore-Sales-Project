/* 
============================================
Creating database and schemas
============================================ 
Script purpose: 
	This script creates a database named 'superstoreSales' Additionally, the script sets up three schemas 
  within the database: 'bronze', 'silver', and 'gold'.
*/

USE master; 
GO

--Creating the 'superstoreSales' database 
CREATE DATABASE superstoreSales; 
GO

USE superstoreSales;
GO


--creating the schema 
CREATE SCHEMA bronze; 
GO 

CREATE SCHEMA silver;
GO 

CREATE SCHEMA gold; 
GO
