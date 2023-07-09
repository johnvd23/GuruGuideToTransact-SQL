USE master
IF OBJECT_ID('sp_helpproccache') IS NOT NULL
  DROP PROC sp_helpproccache
GO
CREATE PROCEDURE sp_helpproccache @dbname sysname = NULL, 
				  @procsonly varchar(3)='NO', 
				  @executableonly varchar(3)='NO'
/*
Object: sp_helproccache
Description: Lists information about the procedure cache
Usage: sp_helproccache @dbname=name of database to list; pass ALL to list all, 
	   @procsonly=[yes|NO] list stored procedures only, 
	   @executableonly=[yes|NO] list executable plans only
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 1.3
Example: EXEC sp_helpproccache "ALL", @proconly="YES"
Created: 1999-06-02.  Last changed: 1999-08-11.
*/
AS
SET NOCOUNT ON
DECLARE @sqlstr varchar(8000)

IF (@dbname='/?') GOTO Help

DBCC PROCCACHE
PRINT ''

SET @sqlstr=
"SELECT LEFT(o.name,30) AS 'Procedure', 
        LEFT(cacheobjtype,30) AS 'Type of Plan', 
	COUNT(*) AS 'Number of Plans' 
FROM master..syscacheobjects c JOIN ?..sysobjects o ON (c.objid=o.id)
WHERE dbid = db_id('?')"+
  CASE @procsonly WHEN 'YES' THEN ' and objtype = "Proc" ' ELSE ' ' END+
  CASE @executableonly WHEN 'YES' THEN 
       ' and cacheobjtype = "Executable Plan" ' ELSE ' ' END+
  "GROUP BY  o.name, cacheobjtype
  ORDER BY  o.name, cacheobjtype"

IF (@dbname='ALL')
	EXEC sp_MSforeachdb @command1="PRINT '***Displaying the procedure cache for database: ?'",
	  @command2='PRINT ""', @command3=@sqlstr
ELSE BEGIN
    PRINT '***Displaying the procedure cache for database: '+DB_NAME()
    PRINT ''
    SET @sqlstr=REPLACE(@sqlstr,'?',DB_NAME())
    EXEC(@sqlstr)
END 
RETURN 0

Help:
EXEC sp_usage @objectname='sp_helproccache',
  	   @desc='Lists information about the procedure cache',
	   @parameters='@dbname=name of database to list; pass ALL to list all, 
	   @procsonly=[yes|NO] list stored procedures only, 
	   @executableonly=[yes|NO] list executable plans only',
	   @example='EXEC sp_helpproccache "ALL", @proconly="YES"',
	   @author='Ken Henderson',
	   @email='khen@khen.com',
	   @version='1', @revision='3',
	   @datecreated='6/2/99', @datelastchanged='8/11/99'
RETURN -1

GO
EXEC sp_helpproccache 'ALL'
