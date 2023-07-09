USE Northwind
SELECT * FROM Orders 
WHERE DATEPART(mm,OrderDate)=5 
AND DATEPART(yy,OrderDate)=1998 
AND (DATEPART(dd,OrderDate) BETWEEN 1 AND 3)

