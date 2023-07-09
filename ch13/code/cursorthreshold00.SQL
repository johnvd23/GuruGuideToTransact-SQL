SET NOCOUNT ON
-- Turn on advanced options so that 'cursor threshold' can be configured
EXEC sp_configure 'show advanced options',1 
RECONFIGURE WITH OVERRIDE

USE northwind

DECLARE c CURSOR STATIC -- Force rows to be copied to tempdb
FOR SELECT OrderID, ProductID FROM [Order Details]

DECLARE @start datetime
SET @start=getdate()

-- First try it with a synchronous cursor
OPEN c 

PRINT CHAR(13) -- Pretty up the display
SELECT DATEDIFF(ms,@start,getdate()) AS [Milliseconds elapsed for Synchronous cursor]

SELECT @@CURSOR_ROWS AS [Number of rows in Synchronous cursor]

CLOSE c

-- Now reconfigure 'cursor threshold' and force an asynch cursor
EXEC sp_configure 'cursor threshold', 1000 -- Asynchronous for cursors > 1000 rows
RECONFIGURE WITH OVERRIDE
PRINT CHAR(13) -- Pretty up the display

SET @start=getdate()
OPEN c -- Opens an asynch cursor since there are over 1000 rows in the table 

-- OPEN comes back immediately because the cursor is being populated asynchronously
SELECT DATEDIFF(ms,@start,getdate()) AS [Milliseconds elapsed for Asynchronous cursor]

SELECT @@CURSOR_ROWS AS [Number of rows in Asynchronous cursor]

CLOSE c

DEALLOCATE c
GO
EXEC sp_configure 'cursor threshold', -1 -- Back to synchronous 
RECONFIGURE WITH OVERRIDE
