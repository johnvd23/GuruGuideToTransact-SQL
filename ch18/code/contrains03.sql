SELECT LastName, FirstName, Notes
FROM EMPLOYEES 
WHERE CONTAINS(*,'English OR German')