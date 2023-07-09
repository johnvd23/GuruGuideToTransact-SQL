SELECT CONVERT(char(6), OrderDate, 112) AS OrderMonth, 
COUNT(*) AS TotalNumberOfOrders -- Use COUNT() to count the number of orders 
FROM Orders
GROUP BY CONVERT(char(6), OrderDate, 112)
ORDER BY OrderMonth
