SELECT fname, lname, hire_date
FROM EMPLOYEE
WHERE CAST(CAST(YEAR(GETDATE()) AS varchar(4))+
SUBSTRING(CONVERT(char(8), hire_date,112),5,4) AS datetime) BETWEEN GETDATE() and GETDATE()+30
