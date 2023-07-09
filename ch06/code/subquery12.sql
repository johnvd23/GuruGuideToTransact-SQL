SELECT c.LastName, c.FirstName 
FROM customers c JOIN (SELECT CustomerNumber, COUNT(DISTINCT ItemNumber) AS NumOfItems
		       FROM orders 
		       GROUP BY CustomerNumber) o ON (c.CustomerNumber=o.CustomerNumber)
WHERE o.NumOfItems=(SELECT COUNT(*) FROM items)
