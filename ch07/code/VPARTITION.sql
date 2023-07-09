USE Northwind
GO
IF (OBJECT_ID('EMP_VIEW') IS NOT NULL)
  DROP VIEW EMP_VIEW
GO
CREATE VIEW EMP_VIEW AS
SELECT 	LastName, 
	FirstName, 
	Title, 
	Extension 
FROM employees
GO
SELECT * FROM EMP_VIEW