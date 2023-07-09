SELECT LastName, FirstName, Notes
FROM EMPLOYEES 
WHERE CONTAINS(Notes,'English')