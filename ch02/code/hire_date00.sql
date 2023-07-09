SELECT fname, lname, hire_date
FROM EMPLOYEE
WHERE MONTH(hire_date)=MONTH(GETDATE())
