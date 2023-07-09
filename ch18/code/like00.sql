SELECT LastName, FirstName, Notes
FROM EMPLOYEES 
WHERE Notes LIKE '%English%' 
OR Notes LIKE '%German%'
