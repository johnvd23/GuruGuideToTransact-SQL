SELECT c.LastName, COUNT(*) AS NumberWithName
FROM CUSTOMERS AS c
GROUP BY c.LastName
