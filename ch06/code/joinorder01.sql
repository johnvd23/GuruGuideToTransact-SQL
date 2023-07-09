SELECT SUM(D.UnitPrice * D.Quantity) AS TotalOrdered
FROM [Order Details] D LEFT OUTER JOIN Products P ON (D.ProductID=P.ProductID)
LEFT OUTER JOIN Orders O ON (O.OrderID+10=D.OrderID)

