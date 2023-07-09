USE master
GO
IF OBJECT_ID('sp_listfile') IS NOT NULL
  DROP PROC sp_listfile
GO
CREATE PROCEDURE sp_listfile @filename sysname
AS
IF (@filename IS NULL) RETURN(-1)

DECLARE @execstr varchar(8000)

SET @execstr='TYPE '+@filename

CREATE TABLE #filecontents
(output		varchar(8000))

INSERT #filecontents
EXEC master..xp_cmdshell @execstr

SELECT * FROM #filecontents
DROP TABLE #filecontents
GO
EXEC sp_listfile 'D:\MSSQL7\INSTALL\README.TXT'
