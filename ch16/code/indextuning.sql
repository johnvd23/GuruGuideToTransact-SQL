SET NOCOUNT ON
USE Northwind
SELECT * INTO OrdersNI FROM Orders
SELECT * INTO OrderDetailsNI FROM [Order Details]
SELECT * INTO CustomersNI FROM Customers

SELECT o.OrderDate, c.CompanyName, SUM(d.UnitPrice * d.Quantity) AS BeforeDiscount
FROM OrdersNI o JOIN OrderDetailsNI d ON (o.OrderID=d.OrderID)
JOIN CustomersNI c ON (o.CustomerID=c.CustomerID)
GROUP BY o.OrderDate, c.CompanyName
ORDER BY o.OrderDate, c.CompanyName

DROP TABLE OrdersNI, OrderDetailsNI, CustomersNI
 