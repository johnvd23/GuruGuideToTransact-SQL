/*

Object: sp_enable_fulltext
Description: Enables full-text indexing for a specified column
Usage: sp_enable_fulltext @tablename=name of host table, @columnname=column to set up
[,@catalogname=name of full-text catalog to use (Default: DB_NAME()+"Catalog")][,@startsrever=YES|NO specifies whether to start the 
Microsoft Search service on this machine prior to setting up the column (Default: YES)]
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Example: EXEC sp_enable_fulltext "pubs..pub_info","pr_info",DEFAULT,"YES"
Created: 1999-06-14.  Last changed: 1999-07-14.

*/

USE master
GO
IF OBJECT_ID('sp_enable_fulltext') IS NOT NULL
  DROP PROC sp_enable_fulltext
GO
CREATE PROC sp_enable_fulltext @tablename sysname, @columnname sysname=NULL, @catalogname sysname=NULL, @startserver varchar(3)='NO'
AS
SET NOCOUNT ON

IF (@tablename='/?') OR (@columnname IS NULL) OR (OBJECT_ID(@tablename) IS NULL) GOTO Help

IF (FULLTEXTSERVICEPROPERTY('IsFulltextInstalled')=0) BEGIN -- Search engine's not installed
  RAISERROR('The Microsoft Search service is not installed on server %s',16,10,@@SERVERNAME)
  RETURN -1
END 

DECLARE @catalogstatus int, @indexname sysname

IF (UPPER(@startserver)='YES')
   EXEC master..xp_cmdshell 'NET START mssearch', no_output

IF (@catalogname IS NULL)
  SET @catalogname=DB_NAME()+'Catalog'

CREATE TABLE #indexes (		-- Used to located a unique index for use with FTS
Qualifier	sysname NULL,
Owner		sysname NULL,
TableName	sysname NULL,
NonUnique	smallint NULL,
IndexQualifier	sysname NULL,
IndexName	sysname NULL,
Type		smallint NULL,
PositionInIndex	smallint NULL,
ColumnName	sysname NULL,
Collation	char(1) NULL,
Cardinality 	int NULL,
Pages		int NULL,
FilterCondition	sysname NULL)

INSERT #indexes
EXEC sp_statistics @tablename

SELECT @indexname=IndexName FROM #indexes WHERE NonUnique=0  -- Get a unique index on the table (gets LAST if multiple)

DROP TABLE #indexes

IF (@indexname IS NULL) BEGIN -- If no unique indexes, abort
  RAISERROR('No suitable unique index found on table %s',16,10,@tablename)
  RETURN -1
END

IF (DATABASEPROPERTY(DB_NAME(),'IsFulltextEnabled')<>1) -- Enable FTS for the database
  EXEC sp_fulltext_database  'enable' 

SET @catalogstatus=FULLTEXTCATALOGPROPERTY(@catalogname,'PopulateStatus')

IF (@catalogstatus IS NULL)		-- Doesn't yet exist
  EXEC sp_fulltext_catalog @catalogname, 'create'    
ELSE IF (@catalogstatus IN (0,1,3,4,6,7)) -- Population in progress, Throttled, Recovering, Incremental Population in Progress or Updating Index
    EXEC sp_fulltext_catalog @catalogname, 'stop'    

IF (OBJECTPROPERTY(OBJECT_ID(@tablename), 'TableHasActiveFullTextIndex')=0) -- Create full text index if not already present
  EXEC sp_fulltext_table @tablename,'create',@catalogname,@indexname
ELSE
  EXEC sp_fulltext_table @tablename,'deactivate'  -- Deactivate it so we can make changes to it

IF (COLUMNPROPERTY(OBJECT_ID(@tablename),@columnname,'IsFulltextIndexed')=0) BEGIN -- Add the column to the index
  EXEC sp_fulltext_column @tablename, @columnname, 'add'
  PRINT 'Successfully added a fulltext index for '+@tablename+'.'+@columnname+' in database '+DB_NAME()
END ELSE
  PRINT 'Column '+@columnname+' in table '+DB_NAME()+'.'+@tablename+' is already full-text indexed'

EXEC sp_fulltext_table @tablename,'activate'

EXEC sp_fulltext_catalog @catalogname, 'start_full'    
RETURN 0

Help:
EXEC sp_usage @objectname='sp_enable_fulltext',@desc='Enables full-text indexing for a specified column',
@parameters='@tablename=name of host table, @columnname=column to set up
[,@catalogname=name of full-text catalog to use (Default: DB_NAME()+"Catalog")][,@startsrever=YES|NO specifies whether to start the 
Microsoft Search service on this machine prior to setting up the column (Default: YES)]',
@author='Ken Henderson', @email='khen@khen.com',
@datecreated='19990614',@datelastchanged='19990714',
@example='EXEC sp_enable_fulltext "pubs..pub_info","pr_info",DEFAULT,"YES"'
RETURN -1


