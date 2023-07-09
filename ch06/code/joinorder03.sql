SELECT O.OrderDate, D.UnitPrice, D.Quantity
FROM [Order Details] D LEFT OUTER JOIN Products P ON (D.ProductID=P.ProductID)
LEFT OUTER JOIN Orders O ON (O.OrderID+10=D.OrderID)
WHERE O.OrderDate IS NULL 
OR D.UnitPrice IS NULL
