USE master
GO
IF OBJECT_ID('sp_copyfile') IS NOT NULL
  DROP PROC sp_copyfile
GO
CREATE PROCEDURE sp_copyfile @sourcefilepath sysname, @targetfilepath sysname=NULL
AS
/*

Object: sp_copyfile
Description: Copies an operating system file
Usage: sp_copyfile @sourcefilepath=full source file path, @targetfilepath=target file path and/or filename
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 6.0
Example: sp_copyfile 'c:\mssql7\backup\masterback.dmp' 'c:\mssql7\backup\masterback.dmp.copy'
sp_copyfile 'c:\mssql7\backup\masterback.dmp' '\\archiveserver\d$\backups' 
sp_copyfile 'c:\mssql8\backup\*.dmp' 'g:\databasedumps' 
Created: 1995-12-19.  Last changed: 1999-06-02.

*/
SET NOCOUNT ON
IF (@sourcefilepath='/?') OR (@targetfilepath IS NULL) GOTO Help

DECLARE @cmdstr varchar(8000)

CREATE TABLE #cmd_result (output varchar(8000))

EXEC master..xp_sprintf @cmdstr OUTPUT, 'copy %s %s',@sourcefilepath, @targetfilepath

INSERT #cmd_result
EXEC master..xp_cmdshell @cmdstr

SELECT * FROM #cmd_result

IF EXISTS(SELECT * FROM #cmd_result WHERE output like '%file(s) copied%') BEGIN
    SET @cmdstr='The file copy operation "'+@cmdstr+'" was successful (at least one file was copied)'
    PRINT @cmdstr
    EXEC master..xp_logevent 60000, @cmdstr, 'INFORMATIONAL'
END ELSE RAISERROR('File copy failed',16,1)

DROP TABLE #cmd_result 
RETURN 0

Help:
EXEC sp_usage @objectname='sp_copyfile',@desc='Copies an operating system file',
@parameters='@sourcefilepath=full source file path, @targetfilepath=target file path and/or filename',
@author='Ken Henderson', @email='khen@khen.com',
@version='6',@revision='0',
@datecreated='19951219',@datelastchanged='19990602',
@example='sp_copyfile ''c:\mssql7\backup\masterback.dmp'' ''c:\mssql7\backup\masterback.dmp.copy''
sp_copyfile ''c:\mssql7\backup\masterback.dmp'' ''\\archiveserver\d$\backups'' 
sp_copyfile ''c:\mssql8\backup\*.dmp'' ''g:\databasedumps'' '

GO


