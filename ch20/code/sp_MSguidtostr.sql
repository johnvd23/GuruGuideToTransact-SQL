DECLARE @guid uniqueidentifier, @guidstr sysname
SET @guid=NEWID()

EXEC sp_MSguidtostr @guid, @guidstr OUT
SELECT @guidstr, convert(sysname, @guid)