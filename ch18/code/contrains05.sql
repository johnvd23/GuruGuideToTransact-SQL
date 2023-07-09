SELECT LastName, FirstName, Notes
FROM EMPLOYEES 
WHERE CONTAINS(*,'"psy*" OR "chem*"')
