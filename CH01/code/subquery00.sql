		SELECT * FROM CUSTOMERS
WHERE CustomerNumber IN (SELECT CustomerNumber FROM ORDERS)
