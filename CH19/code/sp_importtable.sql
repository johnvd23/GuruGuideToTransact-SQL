USE master
GO
IF (OBJECT_ID('sp_importtable') IS NOT NULL)
  DROP PROC sp_importtable
GO
CREATE PROC sp_importtable 
	@table varchar(128), 		-- Table to import
	@inputpath varchar(128)=NULL, 	-- input directory, terminate with a "\"
	@inputname varchar(128)=NULL, 	-- input filename (defaults to @table+'.BCP')
	@server varchar(128)='(local)', -- Name of the server to connect to
	@username varchar(128)='sa',	-- Name of the user to connect as (defaults to 'sa')
	@password varchar(128)=NULL	-- User's password
/*
Object: sp_importtable
Description: Imports a table similarly to BULK INSERT
Usage: sp_importtable 
	@table varchar(128), 		-- Table to import
	@inputpath varchar(128)=NULL, 	-- input directory, terminate with a '\'
	@inputname varchar(128)=NULL, 	-- input filename (defaults to @table+'.BCP')
	@server varchar(128)='(local)', -- Name of the server to connect to
	@username varchar(128)='sa',	-- Name of the user to connect as (defaults to 'sa')
	@password varchar(128)=NULL	-- User's password
Returns: Number of rows imported
Created by: Ken Henderson. Email: khen@khen.com
Example: EXEC importtable "authors", "C:\TEMP\"
Created: 1999-06-14.  Last changed: 1999-07-14.
*/
AS
IF (@table='/?') OR (@inputpath IS NULL) GOTO Help
DECLARE @object int, 	-- Work variable for instantiating COM objects
	@hr int, 	-- Contains HRESULT returned by COM
	@bcobject int, 	-- Stores pointer to BulkCopy object
	@TAB_DELIMITED int,	-- Will store a constant for tab-delimited input
	@logname varchar(128),	-- Name of the log file
	@errname varchar(128),	-- Name of the error file
	@dbname varchar(128),	-- Name of the database
	@rowsimported int	-- Number of rows imported

SET @TAB_DELIMITED=2 -- SQL-DMO constant for tab-delimited imports
SET @dbname=ISNULL(PARSENAME(@table,3),DB_NAME()) -- Extract the DB name; default to current
SET @table=PARSENAME(@table,1)	-- Remove extraneous stuff from table name
IF (@table IS NULL) BEGIN
   RAISERROR('Invalid table name.',16,1)
   RETURN -1
END
IF (RIGHT(@inputpath,1)<>'\')
   SET @inputpath=@inputpath+'\'	-- Append a "\" if necessary
SET @logname=@inputpath+@table+'.LOG' -- Construct the log file name
SET @errname=@inputpath+@table+'.ERR' -- Construct the error file name

IF (@inputname IS NULL)
  SET @inputname=@inputpath+@table+'.BCP' -- Construct the input name based on import table
ELSE
  SET @inputname=@inputpath+@inputname    -- Prefix source path

-- Create a SQLServer object
EXEC @hr=sp_OACreate 'SQLDMO.SQLServer', @object OUT
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END

-- Create a BulkCopy object
EXEC @hr=sp_OACreate 'SQLDMO.BulkCopy', @bcobject OUT 
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @bcobject, @hr
    RETURN
END

-- Set BulkCopy's DataFilePath property to the input file name
EXEC @hr = sp_OASetProperty @bcobject, 'DataFilePath', @inputname 
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @bcobject, @hr
    RETURN
END

-- Tell BulkCopy to create tab-delimited files
EXEC @hr = sp_OASetProperty @bcobject, 'DataFileType', @TAB_DELIMITED
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @bcobject, @hr
    RETURN
END

-- Set BulkCopy's LogFilePath property to the log file name
EXEC @hr = sp_OASetProperty @bcobject, 'LogFilePath', @logname
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @bcobject, @hr
    RETURN
END

-- Set BulkCopy's ErrorFilePath property to the error file name
EXEC @hr = sp_OASetProperty @bcobject, 'ErrorFilePath', @errname
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @bcobject, @hr
    RETURN
END

-- Set BulkCopy's UseServerSideBCP property to true
EXEC @hr = sp_OASetProperty @bcobject, 'UseServerSideBCP', 1
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @bcobject, @hr
    RETURN
END

-- Connect to the server
IF (@password IS NOT NULL)
  EXEC @hr = sp_OAMethod @object, 'Connect', NULL, @server, @username, @password
ELSE
  EXEC @hr = sp_OAMethod @object, 'Connect', NULL, @server, @username
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END

-- Get a pointer to the SQLServer object's Databases collection
EXEC @hr = sp_OAGetProperty @object, 'Databases', @object OUT
IF @hr <> 0 BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END

-- Get a pointer from the Databases collection for the specified database
EXEC @hr = sp_OAMethod @object, 'Item', @object OUT, @dbname
IF @hr <> 0 BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END

-- Get a pointer from the Database object's Tables collection for the specified table
IF (OBJECTPROPERTY(OBJECT_ID(@table),'IsTable')<>1) BEGIN  RAISERROR('Target object must be a table.',16,1)
  RETURN -1
END BEGIN
  EXEC @hr = sp_OAMethod @object, 'Tables', @object OUT, @table
  IF @hr <> 0 BEGIN
      EXEC sp_displayoaerrorinfo @object, @hr
      RETURN
  ENDEND

-- Call the Table object's importData method to import the table using BulkCopy
EXEC @hr = sp_OAMethod @object, 'ImportData', @rowsimported OUT, @bcobject
IF @hr <> 0 BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END

RETURN @rowsimported

Help:

EXEC sp_usage @objectname='sp_importtable',
@desc='Imports a table similarly to BULK INSERT',
@parameters="
	@table varchar(128), 		-- Table to import
	@inputpath varchar(128)=NULL, 	-- input directory, terminate with a '\'
	@inputname varchar(128)=NULL, 	-- input filename (defaults to @table+'.BCP')
	@server varchar(128)='(local)', -- Name of the server to connect to
	@username varchar(128)='sa',	-- Name of the user to connect as (defaults to 'sa')
	@password varchar(128)=NULL	-- User's password
",
@author='Ken Henderson', @email='khen@khen.com',
@datecreated='19990614',@datelastchanged='19990714',
@example='EXEC importtable "authors", "C:\TEMP\"',
@returns='Number of rows imported'
RETURN -1
GO