SELECT SUM(D.UnitPrice*D.Quantity) AS TotalOrdered
FROM Orders O LEFT OUTER JOIN [Order Details] D ON (O.OrderID+10=D.OrderID)
LEFT OUTER JOIN Products P ON (D.ProductID=P.ProductID)
