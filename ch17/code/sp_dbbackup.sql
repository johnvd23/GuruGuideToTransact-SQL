USE master
GO

IF OBJECT_ID('sp_dbbackup') IS NOT NULL
  DROP PROC sp_dbbackup
GO
CREATE PROC sp_dbbackup @dbname sysname='%', 
	@server sysname='(local)', @username sysname=NULL, @password sysname=''
AS
/*

Object: sp_dbbackup
Description: Backups up one or more databases, creating backup devices as needed
Usage: sp_dbbackup [@dbname=database name or mask to backup (Default: '%')],
[,@server="server name"][, @username="user name"][, @password="password"]

Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 7.01
Example: sp_dbbackup 'm%' -- Backs up all databases whose names begin with 'm' 
Created: 1990-01-07.  Last changed: 1999-07-03.

*/
SET NOCOUNT ON
IF (@dbname='/?') GOTO Help

IF (@username IS NULL) SET @username=SUSER_SNAME()

-- Create backup devices and backup each database (except tempdb)

DECLARE @rootpath sysname, @devname sysname, @execstr varchar(8000), @logmessage varchar(8000)
-- Get SQL Server root installation path
EXEC sp_getSQLregistry @regkey='SQLRootPath', @regvalue=@rootpath OUTPUT, @server=@server, 
	@username=@username, @password=@password

DECLARE Databases CURSOR FOR 
	SELECT CATALOG_NAME
	FROM INFORMATION_SCHEMA.SCHEMATA
	WHERE CATALOG_NAME <> 'tempdb' -- Omit system DBs
	AND CATALOG_NAME LIKE @dbname
	ORDER BY CATALOG_NAME

OPEN Databases

FETCH Databases INTO @dbname
SET @devname=@dbname+'back'
WHILE (@@FETCH_STATUS=0) BEGIN
	IF NOT EXISTS(SELECT * FROM master..sysdevices WHERE name = @dbname+'back') BEGIN
		-- Create the data backup device
		PRINT CHAR(13)+'Adding the data backup device for: '+@dbname
		SET @execstr='EXEC sp_addumpdevice ''disk'', "'+@dbname+'back'+'", "'
		+@rootpath+'\backup\'+@dbname+'back.dmp"'
		EXEC(@execstr)
	END

	-- Backup the database
	PRINT CHAR(13)+'Backing up database '+@dbname
	BACKUP DATABASE @dbname TO @devname
	SET @logmessage='Backup of database '+@dbname+' complete'
	EXEC master..xp_logevent 60000, @logmessage, 'INFORMATIONAL'

	-- Backup its log
	IF (@dbname<>'master') AND (DATABASEPROPERTY(@dbname,'IsTruncLog')=0) BEGIN
		IF NOT EXISTS(SELECT * FROM master..sysdevices WHERE name = @dbname+'back') BEGIN
			-- Create the log backup device	
			PRINT 'Adding the log backup device for: '+@dbname
			SET @execstr='EXEC sp_addumpdevice ''disk'', "'+@dbname+'logback'+'", "'
			+@rootpath+'\backup\'+@dbname+'logback.dmp"'
			EXEC(@execstr)
		END

		PRINT 'Backing up the transaction log for: '+@dbname
		SET @devname=@dbname+'logback'
		BACKUP LOG @dbname TO @devname
		SET @logmessage='Backup of the transaction log for database '+@dbname+' complete'
		EXEC master..xp_logevent 60000, @logmessage, 'INFORMATIONAL'
	END

	FETCH Databases INTO @dbname
	SET @devname=@dbname+'back'
END
CLOSE Databases
DEALLOCATE Databases

PRINT CHAR(13)+'Backup operation successfully completed'
RETURN 0

Help:
EXEC sp_usage @objectname='sp_dbbackup', @desc='Backups up one or more databases, creating backup devices as needed',
@parameters='[@dbname=database name or mask to backup (Default: ''%'')]
[,@server="server name"][, @username="user name"][, @password="password"]',
@author='Ken Henderson', @email='khen@khen.com',
@version='7',@revision='01',
@datecreated='19900107', @datelastchanged='19990703',
@example='sp_dbbackup ''m%'' -- Backs up all databases whose names begin with ''m'' '
RETURN -1

GO
