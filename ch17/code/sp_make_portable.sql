USE master
GO
IF OBJECT_ID('sp_make_portable') IS NOT NULL
  DROP PROC sp_make_portable
GO
CREATE PROC sp_make_portable @dbname sysname=NULL, @newdbname sysname=NULL, @objectname sysname='%',
@username sysname=NULL, @password sysname='', @server sysname='(local)'
/*

Object: sp_make_portable
Description: Makes a portable copy of an existing database (schema only - no data)
Usage: sp_make_portable @newdbname=name of new database to create
[,@dbname=database to copy (Default: DB_NAME())]
[,@objectname=mask specifying which objects to copy (Default "%")]
[,@username=user account to use for SQL-DMO (Default: SUSER_SNAME()]
[,@password=password for DMO user account (Default: "")]
[,@server=server to log into (Default: "(local)")]
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 7.0
Example: sp_make_portable @dbname="northwind", @newdbname="northwind2", @user="sa"
Created: 1996-08-03.  Last changed: 1999-07-03.

*/
AS
SET NOCOUNT ON

IF (@dbname='/?') OR (@newdbname='/?') OR (@newdbname IS NULL) GOTO Help

DECLARE @workstr varchar(8000), @sqlpath varchar(8000), @scriptfile sysname, @res int,
@sysdevp sysname, @datadevp sysname, @logdevp sysname,
@sysdevl sysname, @datadevl sysname, @logdevl sysname

IF (@dbname IS NULL) SET @dbname=DB_NAME()		-- Default to copying the current database
IF (@username IS NULL) SET @username=SUSER_SNAME()	-- Use the current user's login name for DMO

IF (DB_ID(@dbname) IS NULL) GOTO Help			-- Invalid source database name

EXEC @res=sp_validname @newdbname,0  			-- Very rudimentary -- doesn't do much
IF (@res=1) GOTO Help

IF (DB_ID(@newdbname) IS NOT NULL)			-- Get rid of target database if it already exists
	EXEC sp_dbremove @newdbname,DROPDEV

EXEC sp_getSQLregistry 'SQLRootPath',@sqlpath OUTPUT, 
	@username=@username, @password=@password, @server=@server	-- Get SQL Server's default installation path
EXEC master..xp_sprintf @workstr OUTPUT, 'DEL %s\\data\\%s.*',
	@sqlpath,@newdbname
EXEC master..xp_cmdshell @workstr, no_output				-- Delete the operating system files for the target DB

SET @sysdevl=@newdbname+'sys'				-- Define logical and physical device names based on
SET @datadevl=@newdbname+'data'				-- the name of the new database
SET @logdevl=@newdbname+'log'
SET @sysdevp=@sqlpath+'\data\'+@newdbname+'.sdf'
SET @datadevp=@sqlpath+'\data\'+@newdbname+'.mdf'
SET @logdevp=@sqlpath+'\data\'+@newdbname+'.ldf'

EXEC master..sp_create_removable			-- Build the new database
	@dbname=@newdbname,
	@syslogical=@sysdevl,
	@sysphysical=@sysdevp,
	@syssize=1,
	@loglogical=@logdevl,
	@logphysical=@logdevp,
	@logsize=1,
	@datalogical1=@datadevl,
	@dataphysical1=@datadevp,
	@datasize1=3

/*
-- Commented out because sp_certify_removable is (7/3/99, SQL 7 SP1) apparently broken.  It reports:
--   Server: Msg 208, Level 16, State 1, Procedure sp_check_portable, Line 18
--   Invalid object name 'sysdatabases'.
-- when called in the following manner:

EXEC @res=master..sp_certify_removable @newdbname, auto	-- Ensure that the new DB is portable
IF (@res<>0) BEGIN
  RAISERROR('Error creating portable database.  Database files sp_certify_removable check',16,1)
  DECLARE @filename sysname
  SET @filename = 'CertifyR_['+@newdbname+'].txt'
  EXEC sp_readtextfile @filename
  RETURN -1
END

EXEC master..sp_dboption @newdbname,'offline',false  -- Set database back online
*/

EXEC master..xp_sprintf @workstr OUTPUT,'EXEC %s..sp_generate_script @objectname="%s", @outputname="%s\%sTEMP.SQL",
	@resultset="NO", @username=''%s'', @password="%s", @server="%s"',
	@dbname,@objectname,@sqlpath,@newdbname, @username, @password, @server
EXEC(@workstr)						-- Generate a script for the old database

EXEC master..xp_sprintf @workstr OUTPUT,'osql -U%s -P%s -S%s -d%s -i%s\%sTEMP.SQL -o%s\%sTEMP.OUT',
	@username,@password,@server,@newdbname,@sqlpath, @newdbname, @sqlpath, @newdbname
EXEC master..xp_cmdshell @workstr, no_output			-- Run the script _in the new database_

PRINT REPLICATE('-',256)+CHAR(13)+'Removable database '+@newdbname+' successfully created'
RETURN 0

Help:
EXEC sp_usage @objectname='sp_make_portable', 
@desc='Makes a portable copy of an existing database (schema only - no data)',
@parameters='@newdbname=name of new database to create
[,@dbname=database to copy (Default: DB_NAME())]
[,@objectname=mask specifying which objects to copy]
[,@username=user account to use for SQL-DMO (Default: SUSER_SNAME()]
[,@password=password for DMO user account (Default: "")]
[,@server=server to log into (Default: "(local)")]',
@author='Ken Henderson', @email='khen@khen.com',@version='7',@revision='0',
@datecreated='19960803', @datelastchanged='19990703',
@example='sp_make_portable @dbname="northwind", @newdbname="northwind2", @user="sa"'
RETURN -1

GO
