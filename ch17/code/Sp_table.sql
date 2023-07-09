USE master
GO
IF OBJECT_ID('sp_table') IS NOT NULL
	DROP PROC sp_table
GO
CREATE PROC sp_table @objectname sysname = '%'
/*

Object: sp_table
Description: Lists the columns in a table
Usage: sp_table [@objectname]=Name of table or view to list catalog info for (defaults to '%')
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 4.2
Example: sp_table "authors"
Created: 1994-02-04.  Last changed: 1999-04-11.

*/
AS
SET NOCOUNT ON
IF (@objectname='/?') GOTO HELP
DECLARE Objects CURSOR FOR 
	SELECT name 
	FROM sysobjects 
	WHERE name like @objectname
	AND type in ('U','S','V')
OPEN Objects
FETCH Objects INTO @objectname
IF (@@FETCH_STATUS<>0) BEGIN  -- No matching objects
	CLOSE Objects
	DEALLOCATE Objects
	PRINT 'No table(s) or view(s) were found that match "'+@objectname+'"'
	GOTO Help
END

WHILE (@@FETCH_STATUS=0) BEGIN
	PRINT 'Name: '+@objectname
	PRINT 'Type: '+CASE WHEN OBJECTPROPERTY(OBJECT_ID(@objectname),'IsUserTable')=1 THEN 'Table'
			WHEN OBJECTPROPERTY(OBJECT_ID(@objectname),'IsSystemTable')=1 THEN 'System Table'
			WHEN OBJECTPROPERTY(OBJECT_ID(@objectname),'IsView')=1 THEN 'View' END
	PRINT CHAR(13)
	SELECT 
		'No.'=C.colid,
		'Name'=LEFT(C.name,30), 
		'Type'=LEFT(CASE WHEN (T.name IN ('char','varchar','nchar','nvarchar')) THEN T.name+'('+LTRIM(RTRIM(STR(C.length)))+')'
			ELSE t.name END,30)+' '+CASE C.status WHEN 1 THEN 'NULL' ELSE 'NOT NULL' END
	FROM syscolumns c JOIN sysobjects o ON (c.id = o.id)
		JOIN systypes t ON (c.xusertype=t.xusertype)
	WHERE o.name = @objectname 
	ORDER BY C.colid
	FETCH Objects INTO @objectname
END
CLOSE Objects
DEALLOCATE Objects

RETURN 0

Help:
	EXEC sp_usage @objectname='sp_table', @desc='Lists the columns in a table',
	@parameters='[@objectname]=Name of table or view to list catalog info for (defaults to ''%'')',
	@example='sp_table "authors"',
	@author='Ken Henderson', @email='khen@khen.com',
	@version='4', @revision='2',
	@datecreated='19940204', @datelastchanged='19990411'
	RETURN -1
GO

