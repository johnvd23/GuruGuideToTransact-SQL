SELECT CUSTOMERS.CustomerNumber, ORDERS.Amount, ITEMS.Description
FROM CUSTOMERS JOIN ORDERS ON (CUSTOMERS.CustomerNumber=ORDERS.CustomerNumber)
JOIN ITEMS ON (ORDERS.ItemNumber=ITEMS.ItemNumber)
