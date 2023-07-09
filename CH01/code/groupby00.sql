SELECT CUSTOMERS.CustomerNumber, SUM(ORDERS.Amount) AS TotalOrders
FROM CUSTOMERS JOIN ORDERS ON CUSTOMERS.CustomerNumber=ORDERS.CustomerNumber
GROUP BY CUSTOMERS.CustomerNumber