USE master
GO
IF OBJECT_ID('sp_updatestats_all') IS NOT NULL
	DROP PROC sp_updatestats_all
GO
CREATE PROC sp_updatestats_all @dbname sysname='%'
/*

Object: sp_updatestats_all
Description: Updates index statistics for a given database or databases
Usage: sp_updatestats_all [@dbname=Name of database to update (Default: "%")]
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 4.2
Example: sp_updatestats_all "pubs"
Created: 1991-09-12.  Last changed: 1999-05-03.

*/
AS
SET NOCOUNT ON
IF (@dbname='/?') GOTO Help
DECLARE Databases CURSOR FOR 
	SELECT CATALOG_NAME
	FROM INFORMATION_SCHEMA.SCHEMATA
	WHERE NOT (CATALOG_NAME IN ('tempdb','master','msdb','model')) -- Omit system DBs
	AND CATALOG_NAME LIKE @dbname
DECLARE	@execstr varchar(8000)

OPEN Databases

FETCH Databases INTO @dbname
IF (@@FETCH_STATUS<>0) BEGIN  -- No matching databases
	CLOSE Databases
	DEALLOCATE Databases
	PRINT 'No databases were found that match "'+@dbname+'"'
	GOTO Help
END

WHILE (@@FETCH_STATUS=0) BEGIN
	PRINT CHAR(13)+'Updating statistics information for database: '+@dbname
	SET @execstr='EXEC '+@dbname+'..sp_updatestats'  -- Prefixing the DB name temporarily changes the current DB
	EXEC(@execstr)
	FETCH Databases INTO @dbname
END
CLOSE Databases
DEALLOCATE Databases
RETURN 0

Help:
EXEC sp_usage @objectname='sp_updatestats_all', @desc='Updates index statistics for a given database or databases',
@parameters='[@dbname=Name of database to update (Default: "%")]',
@author='Ken Henderson', @email='khen@khen.com',
@version='4', @revision='2',
@datecreated='19910912', @datelastchanged='19990503',
@example='sp_updatestats_all "pubs"'
RETURN -1
