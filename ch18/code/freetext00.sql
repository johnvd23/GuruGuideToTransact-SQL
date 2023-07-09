SELECT LastName, FirstName, Notes
FROM EMPLOYEES 
WHERE FREETEXT(Notes,'BA BTS BCS degree')
