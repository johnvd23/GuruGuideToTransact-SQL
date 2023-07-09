SET NOCOUNT ON
USE Northwind
GO
BEGIN TRAN  -- So we can undo all this

DECLARE @pagebin binary(6), @file int, @page int

-- Get the first page of the table (usually)
SELECT TOP 1 @pagebin=first 
FROM sysindexes 
WHERE id=OBJECT_ID('Orders') 
ORDER BY indid

-- Translate first into a file and page number
EXEC sp_decodepagebin @pagebin, @file OUT, @page OUT 

-- Show the first file and page in the table
-- Look at the m_slotCnt column in the page header to determine
-- the number of row/page for this page.
DBCC TRACEON(3604)
PRINT CHAR(13)
PRINT '***Dumping the first page of Orders BEFORE the partitioning'
DBCC PAGE('Northwind',@file,@page,0,1) 

-- Run a query so we can check the cost of the query
-- before the partitioning
SELECT * 
INTO #ordertmp1
FROM Orders

-- Now partition the table vertically into two separate tables

-- Create a table to hold the primary order information
SELECT OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate
INTO OrdersMain
FROM Orders

-- Add a clustered primary key
ALTER TABLE OrdersMain ADD CONSTRAINT PK_OrdersMain PRIMARY KEY (OrderID)

-- Create a table that will store shipping info only
SELECT OrderID, Freight, ShipVia, ShipName, ShipAddress, ShipCity, ShipRegion,
ShipPostalCode, ShipCountry 
INTO OrdersShipping 
FROM Orders

-- Add a clustered primary key
ALTER TABLE OrdersShipping ADD CONSTRAINT PK_OrdersShipping PRIMARY KEY (OrderID) 

-- Now check the number of rows/page in the first of the new tables.
-- Vertically partitioning Orders has increased the number of rows/page
-- and should speed up queries
SELECT TOP 1 @pagebin=first 
FROM sysindexes 
WHERE id=OBJECT_ID('OrdersMain') 
ORDER BY indid

EXEC sp_decodepagebin @pagebin, @file OUT, @page OUT

PRINT CHAR(13)
PRINT '***Dumping the first page of OrdersMain AFTER the partitioning'
DBCC PAGE('Northwind',@file,@page,0,1)

-- Run a query so we can check the cost of the query
-- after the partitioning
SELECT * 
INTO #ordertmp2
FROM OrdersMain

-- Check the number of rows/page in the second table.
SELECT TOP 1 @pagebin=first 
FROM sysindexes 
WHERE id=OBJECT_ID('OrdersShipping') 
ORDER BY indid

EXEC sp_decodepagebin @pagebin, @file OUT, @page OUT

PRINT CHAR(13)
PRINT '***Dumping the first page of OrdersShipping AFTER the partitioning'
DBCC PAGE('Northwind',@file,@page,0,1)
DBCC TRACEOFF(3604)

DROP TABLE #ordertmp1
DROP TABLE #ordertmp2

GO
ROLLBACK TRAN -- Undo it all
