USE Northwind
GO
ALTER TABLE Orders ADD DaysToShip AS CASE WHEN ShippedDate IS NULL THEN DATEDIFF(dd,OrderDate,RequiredDate) ELSE NULL END
GO
SELECT OrderId, CONVERT(char(10),OrderDate,101) AS OrderDate, 
		CONVERT(char(10),RequiredDate,101) AS RequiredDate, 
		CONVERT(char(10),ShippedDate,101) AS ShippedDate, 
		DaysToShip FROM Orders
GO
ALTER TABLE Orders DROP COLUMN DaysToShip 
GO
