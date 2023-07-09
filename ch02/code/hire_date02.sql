SELECT fname, lname, hire_date
FROM employee
WHERE DATEDIFF(dd,GETDATE(),DATEADD(yy,DATEDIFF(yy, hire_date,GETDATE()),hire_date))
BETWEEN 0 and 30


