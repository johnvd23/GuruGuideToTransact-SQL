SET NOCOUNT ON
USE Northwind
BEGIN TRAN  -- Start a tran so we can undo all this
GO
ALTER TABLE Orders ADD NumberOfOrders int DEFAULT 1  -- Add summary column
GO
UPDATE Orders SET NumberOfOrders=DEFAULT -- Force all current rows to contain DEFAULT value
GO
-- Insert summary info
INSERT Orders (CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, 
		ShipVia, Freight, ShipName, ShipAddress, ShipCity, 
		ShipRegion, ShipPostalCode, ShipCountry, NumberOfOrders)
SELECT NULL, EmployeeID, CONVERT(char(6), OrderDate, 112)+'01', 
	'19000101', '19000101',1,0,'','','','','','',COUNT(*) -- Summarize rows
FROM Orders 
WHERE OrderDate < '19980101' 
GROUP BY EmployeeID, CONVERT(char(6), OrderDate, 112)+'01' 

-- Delete Order Details rows corresponding to summarized rows
DELETE d
FROM [Order Details] d JOIN Orders o ON d.OrderID=o.OrderID
WHERE o.OrderDate <'19980101' AND RequiredDate > '19000101' -- Use RequiredDate to leave summary rows

-- Delete non-summary versions of rows that were summarized
DELETE Orders
WHERE OrderDate < '19980101' AND RequiredDate > '19000101' -- Use RequiredDate to leave summary rows

SELECT CONVERT(char(6), OrderDate, 112) AS OrderMonth, 
SUM(NumberOfOrders) AS TotalNumberOfOrders  -- Use SUM to return the order count
FROM Orders
GROUP BY CONVERT(char(6), OrderDate, 112)
ORDER BY OrderMonth

SELECT CustomerID, EmployeeID, OrderDate, RequiredDate, NumberOfOrders FROM Orders
WHERE OrderDate BETWEEN '19971201' AND '19980101'
ORDER BY OrderDate, EmployeeID

GO
ROLLBACK TRAN  -- Undo everything
