-- Bad SQL – don’t do this
SELECT CUSTOMERS.LastName, COUNT(*) AS NumberWithName
FROM CUSTOMERS
GROUP BY CUSTOMERS.LastName
HAVING CUSTOMERS.LastName<>'Citizen'
