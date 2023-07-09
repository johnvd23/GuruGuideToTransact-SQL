CREATE PROC sp_testbit AS
SELECT 1
GO
EXEC sp_ms_marksystemobject 'sp_testbit'
SELECT OBJECTPROPERTY(OBJECT_ID('sp_testbit'),'IsMSShipped')
