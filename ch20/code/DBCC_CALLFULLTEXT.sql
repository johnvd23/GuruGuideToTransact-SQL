USE master
GO
IF OBJECT_ID('sp_fulltext_resource') IS NOT NULL
  DROP PROC sp_fulltext_resource
GO
CREATE PROC sp_fulltext_resource @value	int -- value for 'resource_usage'
AS
	DBCC CALLFULLTEXT(9,@value)	-- FTSetResource (@value)
	IF (@@error<>0) RETURN 1
	-- SUCCESS --
RETURN 0	-- sp_fulltext_resource
GO

EXEC sp_MS_marksystemobject 'sp_fulltext_resource'
EXEC sp_fulltext_resource 3
