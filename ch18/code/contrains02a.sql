SELECT LastName, FirstName, Notes
FROM EMPLOYEES 
WHERE CONTAINS(*,'degree ~ English')