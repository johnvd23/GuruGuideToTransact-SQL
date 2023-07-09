SELECT LastName, FirstName, Notes
FROM EMPLOYEES 
WHERE 
CONTAINS(*,'ISABOUT(English weight(.8), German weight(.4), 
Italian weight(.2), French weight (.1))')

