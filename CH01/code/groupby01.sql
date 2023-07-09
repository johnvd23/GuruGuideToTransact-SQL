-- Bad SQL – don’t do this
SELECT CUSTOMERS.CustomerNumber, CUSTOMERS.LastName, SUM(ORDERS.Amount) AS TotalOrders
FROM CUSTOMERS JOIN ORDERS ON CUSTOMERS.CustomerNumber=ORDERS.CustomerNumber
GROUP BY CUSTOMERS.CustomerNumber
