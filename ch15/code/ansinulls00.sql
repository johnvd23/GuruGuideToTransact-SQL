USE Northwind
IF (OBJECT_ID('dbo.ListRegionalEmployees') IS NOT NULL)
  DROP PROC dbo.ListRegionalEmployees
GO
SET ANSI_NULLS OFF
GO
CREATE PROC dbo.ListRegionalEmployees @region nvarchar(30)
AS

SELECT EmployeeID, LastName, FirstName, Region FROM employees
WHERE Region=@region

GO
SET ANSI_NULLS ON
GO

