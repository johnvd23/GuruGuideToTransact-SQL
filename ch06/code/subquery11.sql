SELECT c.LastName,c.FirstName 
FROM customers c
WHERE NOT EXISTS (SELECT * 
		  FROM items i
		  WHERE NOT EXISTS 
		  (SELECT *
		   FROM items t JOIN orders o ON (t.ItemNumber=o.ItemNumber)
		   WHERE t.ItemNumber=i.ItemNumber AND o.CustomerNumber=c.CustomerNumber))
