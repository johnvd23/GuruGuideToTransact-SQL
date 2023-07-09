SELECT c.LastName, c.FirstName 
FROM customers c JOIN orders o ON (c.CustomerNumber=o.CustomerNumber)
JOIN items i ON (o.ItemNumber=i.ItemNumber)
GROUP BY c.LastName, c.FirstName
HAVING COUNT(DISTINCT o.ItemNumber)=(SELECT COUNT(*) FROM items)
