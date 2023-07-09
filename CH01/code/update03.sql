UPDATE o
SET Amount=Price
FROM ORDERS o JOIN ITEMS i ON (o.ItemNumber=i.ItemNumber)
