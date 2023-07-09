USE master
GO
IF (OBJECT_ID('sp_get_sid') IS NOT NULL)
  DROP PROC sp_get_sid
GO
CREATE PROCEDURE sp_get_sid
    @loginame	sysname
AS
DECLARE @sid varbinary(85)

IF (charindex('\', @loginame) = 0) 
	SELECT SUSER_SID(@loginame) AS 'SQL User ID'
ELSE BEGIN
	SELECT @sid=get_sid('\U'+@loginame, NULL) 
	IF @sid IS NULL
	    SELECT @sid=get_sid('\G'+@loginame, NULL) -- Maybe it's a group
	IF @sid IS NULL BEGIN
	  RAISERROR('Couldn''t find an ID for the specified loginame',16,10)
          RETURN -1
        END ELSE SELECT @sid AS 'NT User ID' 
	RETURN 0
END
GO
EXEC sp_MS_marksystemobject 'sp_get_sid'
EXEC sp_get_sid 'LEX_TALIONIS\KHEN'

