SET NOCOUNT ON
USE Northwind

-- Build non-indexed versions of a couple tables
SELECT * INTO OrdersNonIndexed FROM Orders
SELECT * INTO CustomersNonIndexed FROM Customers

SELECT COUNT(*)
FROM OrdersNonIndexed o JOIN CustomersNonIndexed c
ON (o.CustomerID=c.CustomerID)
GO
DROP TABLE OrdersNonIndexed, CustomersNonIndexed
