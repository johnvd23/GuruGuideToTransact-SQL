DECLARE @tabid int, @colname sysname, @type nvarchar(4000)
SET @tabid=OBJECT_ID('authors')
EXEC sp_MSget_type @tabid, 1, @colname OUT, @type OUT
SELECT @colname, @type