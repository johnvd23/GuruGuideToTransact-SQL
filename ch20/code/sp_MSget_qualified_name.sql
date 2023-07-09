DECLARE @oid int, @obname sysname
SET @oid=OBJECT_ID('titles')
EXEC sp_MSget_qualified_name @oid, @obname OUT
SELECT @obname