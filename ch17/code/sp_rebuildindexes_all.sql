USE master
GO
IF OBJECT_ID('sp_rebuildindexes_all') IS NOT NULL
	DROP PROC sp_rebuildindexes_all
GO
IF OBJECT_ID('sp_rebuildindexes') IS NOT NULL
	DROP PROC sp_rebuildindexes
GO

CREATE PROC sp_rebuildindexes @tablename sysname='%' AS
SET NOCOUNT ON

DECLARE @execstr varchar(8000)
DECLARE Tables CURSOR FOR
	-- Tried to use INFORMATION_SCHEMA.TABLES here but it refused to work
	SELECT name
	FROM sysobjects
	WHERE OBJECTPROPERTY(OBJECT_ID(name),'IsUserTable')=1  -- Exclude views and system tables
	AND name LIKE @tablename
OPEN Tables
FETCH Tables INTO @tablename
WHILE (@@FETCH_STATUS=0) BEGIN
	PRINT CHAR(13)+'Rebuilding indexes for: '+@tablename
	SET @execstr='DBCC DBREINDEX('+@tablename+')'
	EXEC(@execstr)
	FETCH Tables INTO @tablename
END
CLOSE Tables
DEALLOCATE Tables
RETURN 0
GO

CREATE PROC sp_rebuildindexes_all @dbname sysname='%'
/*

Object: sp_rebuildindexes_all
Description: Rebuilds the indexes for all tables in a given database or databases
Usage: sp_rebuildindexes_all [@dbname=Name of database to update (Default: "%")]
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 4.2
Example: sp_rebuildindexes_all "pubs"
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
DECLARE	@execstr varchar(8000), @tablename sysname

OPEN Databases

FETCH Databases INTO @dbname
IF (@@FETCH_STATUS<>0) BEGIN  -- No matching databases
	CLOSE Databases
	DEALLOCATE Databases
	PRINT 'No databases were found that match "'+@dbname+'"'
	GOTO Help
END

WHILE (@@FETCH_STATUS=0) BEGIN
	PRINT CHAR(13)+'Rebuilding indexes in database: '+@dbname
	PRINT CHAR(13)
	SET @execstr='EXEC '+@dbname+'..sp_rebuildindexes'  -- Prefixing DB name temporarily changes current DB
	EXEC(@execstr)
	FETCH Databases INTO @dbname
END
CLOSE Databases
DEALLOCATE Databases
RETURN 0

Help:
EXEC sp_usage @objectname='sp_rebuildindexes_all', 
@desc='Rebuilds the indexes for all tables in a given database or databases',
@parameters='[@dbname=Name of database to update (Default: "%")]',
@author='Ken Henderson', @email='khen@khen.com',
@version='4', @revision='2',
@datecreated='19910912', @datelastchanged='19990503',
@example='sp_rebuildindexes_all "pubs"'
RETURN -1

GO
