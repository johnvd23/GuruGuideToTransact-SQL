SET NOCOUNT ON
USE Northwind

BEGIN TRAN

-- Drop the redundant primary key index to keep it from covering the query
ALTER TABLE [Order Details] DROP CONSTRAINT PK_Order_Details

SELECT ProductID, OrderID, UnitPrice, COUNT(*)
FROM [Order Details]
WHERE ProductID=20
AND OrderID BETWEEN 10200 AND 10300
GROUP BY ProductID, OrderID, UnitPrice
GO
ROLLBACK TRAN
