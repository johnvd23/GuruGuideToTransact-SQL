USE Northwind
SELECT *
FROM Orders o JOIN [Order Details] d ON (o.OrderID = d.OrderID)
