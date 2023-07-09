SET NOCOUNT ON
USE Northwind
GO
BEGIN TRAN

SELECT COUNT(*) AS TotalCustomersBefore FROM Customers

DELETE c
FROM Customers c LEFT OUTER JOIN Orders o ON (c.CustomerID=o.CustomerID)
WHERE o.OrderID IS NULL

SELECT COUNT(*) AS TotalCustomersAfter FROM Customers

GO
ROLLBACK TRAN