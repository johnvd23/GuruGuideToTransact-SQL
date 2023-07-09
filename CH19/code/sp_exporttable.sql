USE master
GO
IF (OBJECT_ID('sp_exporttable') IS NOT NULL)
  DROP PROC sp_exporttable
GO
CREATE PROC sp_exporttable 
	@table varchar(128), 		-- Table to export
	@outputpath varchar(128)=NULL, 	-- Output directory, terminate with a "\"
	@outputname varchar(128)=NULL, 	-- Output filename (defaults to @table+'.BCP')
	@server varchar(128)='(local)', -- Name of the server to connect to
	@username varchar(128)='sa',	-- Name of the user to connect as (defaults to 'sa')
	@password varchar(128)=NULL	-- User's password
/*
Object: sp_exporttable
Description: Exports a table in a manner similar to BULK INSERT
Usage: sp_exporttable 
	@table varchar(128), 		-- Table to export
	@outputpath varchar(128)=NULL, 	-- Output directory, terminate with a '\'
	@outputname varchar(128)=NULL, 	-- Output filename (defaults to @table+'.BCP')
	@server varchar(128)='(local)', -- Name of the server to connect to
	@username varchar(128)='sa',	-- Name of the user to connect as (defaults to 'sa')
	@password varchar(128)=NULL	-- User's password
Returns: Number of rows exported
Created by: Ken Henderson. Email: khen@khen.com
Example: EXEC sp_exporttable "authors"
Created: 1999-06-14.  Last changed: 1999-07-14.
*/
AS
IF (@table='/?') OR (@outputpath IS NULL) GOTO Help
DECLARE @object int, 	-- Work variable for instantiating COM objects
	@hr int, 	-- Contains HRESULT returned by COM
	@bcobject int, 	-- Stores pointer to BulkCopy object
	@TAB_DELIMITED int,	-- Will store a constant for tab-delimited output
	@logname varchar(128),	-- Name of the log file
	@errname varchar(128),	-- Name of the error file
	@dbname varchar(128),	-- Name of the database
	@rowsexported int	-- Number of rows exported

SET @TAB_DELIMITED=2 -- SQL-DMO constant for tab-delimited exports
SET @dbname=ISNULL(PARSENAME(@table,3),DB_NAME()) -- Extract the DB name; default to current
SET @table=PARSENAME(@table,1)	-- Remove extraneous stuff from table name
IF (@table IS NULL) BEGIN
   RAISERROR('Invalid table name.',16,1)
   GOTO Help
END
IF (RIGHT(@outputpath,1)<>'\')
   SET @outputpath=@outputpath+'\'	-- Append a "\" if necessary
SET @logname=@outputpath+@table+'.LOG' -- Construct the log file name
SET @errname=@outputpath+@table+'.ERR' -- Construct the error file name

IF (@outputname IS NULL)
  SET @outputname=@outputpath+@table+'.BCP' -- Construct the output name based on export table
ELSE
  IF (CHARINDEX('\',@outputname)=0)
    SET @outputname=@outputpath+@outputname

-- Create a SQLServer object
EXEC @hr=sp_OACreate 'SQLDMO.SQLServer', @object OUTPUT
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END

-- Create a BulkCopy object
EXEC @hr=sp_OACreate 'SQLDMO.BulkCopy', @bcobject OUTPUT 
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @bcobject, @hr
    RETURN
END

-- Set BulkCopy's DataFilePath property to the output file name
EXEC @hr = sp_OASetProperty @bcobject, 'DataFilePath', @outputname 
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

-- Get a pointer from the Database object's Tables collection for the table
IF (OBJECTPROPERTY(OBJECT_ID(@table),'IsTable')=1) BEGIN  EXEC @hr = sp_OAMethod @object, 'Tables', @object OUT, @table
  IF @hr <> 0 BEGIN
      EXEC sp_displayoaerrorinfo @object, @hr
      RETURN
  ENDEND ELSE -- Get a pointer from the Database object's View collection for the view
IF (OBJECTPROPERTY(OBJECT_ID(@table),'IsView')=1) BEGIN  EXEC @hr = sp_OAMethod @object, 'Views', @object OUT, @table
  IF @hr <> 0 BEGIN
      EXEC sp_displayoaerrorinfo @object, @hr
      RETURN
  ENDEND ELSE BEGIN
  RAISERROR('Source object must be either a table or view.',16,1)
  RETURN -1
END

-- Call the object's ExportData method to export the table/view using BulkCopy
EXEC @hr = sp_OAMethod @object, 'ExportData', @rowsexported OUT, @bcobject
IF @hr <> 0 BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END

RETURN @rowsexported

Help:

EXEC sp_usage @objectname='sp_exporttable',
@desc='Exports a table in a manner similar to BULK INSERT',
@parameters="
	@table varchar(128), 		-- Table to export
	@outputpath varchar(128)=NULL, 	-- Output directory, terminate with a '\'
	@outputname varchar(128)=NULL, 	-- Output filename (defaults to @table+'.BCP')
	@server varchar(128)='(local)', -- Name of the server to connect to
	@username varchar(128)='sa',	-- Name of the user to connect as (defaults to 'sa')
	@password varchar(128)=NULL	-- User's password
",
@author='Ken Henderson', @email='khen@khen.com',
@datecreated='19990614',@datelastchanged='19990714',
@example='EXEC sp_exporttable "authors", "C:\TEMP\"',
@returns='Number of rows exported'
RETURN -1
GO