SELECT CUSTOMERS.CustomerNumber, ORDERS.Amount, ITEMS.Description
FROM CUSTOMERS, ORDERS, ITEMS
WHERE CUSTOMERS.CustomerNumber=ORDERS.CustomerNumber
AND ORDERS.ItemNumber=ITEMS.ItemNumber
