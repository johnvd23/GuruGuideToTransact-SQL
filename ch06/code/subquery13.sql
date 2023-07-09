SELECT c.LastName, c.FirstName 
FROM customers c 
WHERE CustomerNumber IN (SELECT CustomerNumber FROM orders GROUP BY CustomerNumber
			 HAVING COUNT(DISTINCT ItemNumber)=(SELECT COUNT(*) FROM items))
