SELECT CUSTOMERS.CustomerNumber, CUSTOMERS.LastName, SUM(ORDERS.Amount) AS TotalOrders
FROM CUSTOMERS JOIN ORDERS ON CUSTOMERS.CustomerNumber=ORDERS.CustomerNumber
GROUP BY CUSTOMERS.CustomerNumber, CUSTOMERS.LastName
HAVING SUM(ORDERS.Amount) > 700
