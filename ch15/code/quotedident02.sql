USE Northwind
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('dbo.listorders') IS NOT NULL
  DROP PROC dbo.listorders
GO
CREATE PROC dbo.listorders 
AS
SELECT * FROM "Order Details"
GO
SET QUOTED_IDENTIFIER OFF
GO
