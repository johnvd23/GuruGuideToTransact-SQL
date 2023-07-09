SET NOCOUNT ON
USE Northwind

BEGIN TRAN

-- Drop the redundant primary key index to keep it from covering the query
ALTER TABLE [Order Details] DROP CONSTRAINT PK_Order_Details

SELECT ProductID, OrderID, COUNT(*)
FROM [Order Details]
WHERE ProductID BETWEEN 20 AND 40
AND OrderID BETWEEN 10300 AND 10350
GROUP BY ProductID, OrderID
GO
ROLLBACK TRAN
