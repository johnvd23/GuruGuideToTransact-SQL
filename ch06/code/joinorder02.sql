SELECT O.OrderDate, D.UnitPrice, D.Quantity
FROM Orders O LEFT OUTER JOIN [Order Details] D ON (O.OrderID+10=D.OrderID)
LEFT OUTER JOIN Products P ON (D.ProductID=P.ProductID)
WHERE O.OrderDate IS NULL 
OR D.UnitPrice IS NULL
