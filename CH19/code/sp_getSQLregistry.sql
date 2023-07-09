USE master
GO
IF OBJECT_ID('sp_getSQLregistry') IS NOT NULL
  DROP PROC sp_getSQLregistry
GO
CREATE PROC sp_getSQLregistry 
	@regkey varchar(128),			-- Registry key to extract
	@regvalue varchar(8000)=NULL	OUTPUT, -- Value from SQL Server registry tree for key
	@server varchar(128)='(local)', 	-- Name of the server to connect to
	@username varchar(128)='sa',		-- Name of the user to connect as (defaults to 'sa')
	@password varchar(128)=NULL		-- User's password

/*

Object: sp_getSQLregistry
Description: Retrieves a value from the SQL Server branch in the system registry
Usage: sp_getSQLregistry 
	@regkey varchar(128),		-- Registry key to extract
	@regvalue varchar(8000)	OUTPUT,  -- Value from SQL Server registry tree for key
	@server varchar(128)="(local)", -- Name of the server to connect to
	@username varchar(128)="sa",	-- Name of the user to connect as (Default: "sa")
	@password varchar(128)=NULL	-- User's password
Returns: Data length of registry value
Created by: Ken Henderson. Email: khen@khen.com
Version: 6.4
Example: sp_getSQLregistry "SQLRootPath", @sqlpath OUTPUT
Created: 1996-09-03.  Last changed: 1999-07-01.
                                                                                                                                 
*/
AS
SET NOCOUNT ON
IF (@regkey='/?') GOTO Help

DECLARE @object int, 		-- Work variable for instantiating COM objects
	@hr int 		-- Contains HRESULT returned by COM

-- Create a SQLServer object
EXEC @hr=sp_OACreate 'SQLDMO.SQLServer', @object OUTPUT
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END

-- Connect to the server
IF (@password IS NOT NULL) AND (@password<>'')
  EXEC @hr = sp_OAMethod @object, 'Connect', NULL, @server, @username, @password
ELSE
  EXEC @hr = sp_OAMethod @object, 'Connect', NULL, @server, @username
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END

-- Get a pointer to the SQLServer object's Registry object
EXEC @hr = sp_OAGetProperty @object, 'Registry', @object OUT
IF @hr <> 0 BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END


-- Get a pointer to the SQLServer object's Databases collection
EXEC @hr = sp_OAGetProperty @object, @regkey, @regvalue OUT
IF @hr <> 0 BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END

RETURN datalength(@regvalue)

Help:
EXEC sp_usage @objectname='sp_getSQLregistry', 
@desc='Retrieves a value from the SQL Server branch in the system registry',
@parameters='
	@regkey varchar(128),		-- Registry key to extract
	@regvalue varchar(8000)	OUTPUT,  -- Value from SQL Server registry tree for key
	@server varchar(128)="(local)", -- Name of the server to connect to
	@username varchar(128)="sa",	-- Name of the user to connect as (Default: "sa")
	@password varchar(128)=NULL	-- User''s password',
@author='Ken Henderson', @email='khen@khen.com',
@datecreated='19960903', @datelastchanged='19990701',
@version='6', @revision='4',
@returns='Data length of registry value',
@example='sp_getSQLregistry "SQLRootPath", @sqlpath OUTPUT'

GO