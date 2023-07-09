USE master
GO
IF OBJECT_ID('sp_generate_script') IS NOT NULL
  DROP PROC sp_generate_script
GO
CREATE PROC sp_generate_script 
	@objectname sysname=NULL,	-- Object mask to copy
	@outputname sysname=NULL,	-- Output file to create (default: @objectname+'.SQL')
	@scriptoptions int=NULL,	-- Options bitmask for Transfer
	@resultset varchar(3)="YES",	-- Determines whether the script is returned as a result set
	@server sysname='(local)', 	-- Name of the server to connect to
	@username sysname='sa',		-- Name of the user to connect as (defaults to 'sa')
	@password sysname=NULL		-- User's password
/*

Object: sp_generate_script
Description: Generates a creation script for an object or collection of objects
Usage: sp_generate_script [@objectname="Object name or mask (defaults to all object in current database)"]
				[,@outputname="Output file name" (Default: @objectname+".SQL", or GENERATED_SCRIPT.SQL for entire database)]
				[,@scriptoptions=bitmask specifying script generation options]
				[,@resultset="YES"|"NO" -- determines whether to return the script as a result set (Default: "YES")]
				[,@server="server name"][, @username="user name"][, @password="password"]
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 2.0
Created: 1996-12-01.  Last changed: 1999-06-06.
*/
AS

-- SQLDMO_SCRIPT_TYPE vars
DECLARE @SQLDMOScript_Default int
DECLARE @SQLDMOScript_Drops int
DECLARE @SQLDMOScript_ObjectPermissions int
DECLARE @SQLDMOScript_PrimaryObject int
DECLARE @SQLDMOScript_ClusteredIndexes int
DECLARE @SQLDMOScript_Triggers int
DECLARE @SQLDMOScript_DatabasePermissions int
DECLARE @SQLDMOScript_Permissions int
DECLARE @SQLDMOScript_ToFileOnly int
DECLARE @SQLDMOScript_Bindings int
DECLARE @SQLDMOScript_AppendToFile int
DECLARE @SQLDMOScript_NoDRI int
DECLARE @SQLDMOScript_UDDTsToBaseType int
DECLARE @SQLDMOScript_IncludeIfNotExists int
DECLARE @SQLDMOScript_NonClusteredIndexes int
DECLARE @SQLDMOScript_Indexes int
DECLARE @SQLDMOScript_Aliases int
DECLARE @SQLDMOScript_NoCommandTerm int
DECLARE @SQLDMOScript_DRIIndexes int
DECLARE @SQLDMOScript_IncludeHeaders int
DECLARE @SQLDMOScript_OwnerQualify int
DECLARE @SQLDMOScript_TimestampToBinary int
DECLARE @SQLDMOScript_SortedData int
DECLARE @SQLDMOScript_SortedDataReorg int
DECLARE @SQLDMOScript_TransferDefault int
DECLARE @SQLDMOScript_DRI_NonClustered int
DECLARE @SQLDMOScript_DRI_Clustered int
DECLARE @SQLDMOScript_DRI_Checks int
DECLARE @SQLDMOScript_DRI_Defaults int
DECLARE @SQLDMOScript_DRI_UniqueKeys int
DECLARE @SQLDMOScript_DRI_ForeignKeys int
DECLARE @SQLDMOScript_DRI_PrimaryKey int
DECLARE @SQLDMOScript_DRI_AllKeys int
DECLARE @SQLDMOScript_DRI_AllConstraints int
DECLARE @SQLDMOScript_DRI_All int
DECLARE @SQLDMOScript_DRIWithNoCheck int
DECLARE @SQLDMOScript_NoIdentity int
DECLARE @SQLDMOScript_UseQuotedIdentifiers int

-- SQLDMO_SCRIPT2_TYPE vars
DECLARE @SQLDMOScript2_Default int
DECLARE @SQLDMOScript2_AnsiPadding int
DECLARE @SQLDMOScript2_AnsiFile int
DECLARE @SQLDMOScript2_UnicodeFile int
DECLARE @SQLDMOScript2_NonStop int
DECLARE @SQLDMOScript2_NoFG int
DECLARE @SQLDMOScript2_MarkTriggers int
DECLARE @SQLDMOScript2_OnlyUserTriggers int
DECLARE @SQLDMOScript2_EncryptPWD int
DECLARE @SQLDMOScript2_SeparateXPs int

-- SQLDMO_SCRIPT_TYPE values
SET @SQLDMOScript_Default = 4
SET @SQLDMOScript_Drops = 1
SET @SQLDMOScript_ObjectPermissions = 2
SET @SQLDMOScript_PrimaryObject = 4
SET @SQLDMOScript_ClusteredIndexes = 8
SET @SQLDMOScript_Triggers = 16
SET @SQLDMOScript_DatabasePermissions = 32
SET @SQLDMOScript_Permissions = 34
SET @SQLDMOScript_ToFileOnly = 64
SET @SQLDMOScript_Bindings = 128
SET @SQLDMOScript_AppendToFile = 256
SET @SQLDMOScript_NoDRI = 512
SET @SQLDMOScript_UDDTsToBaseType = 1024
SET @SQLDMOScript_IncludeIfNotExists = 4096
SET @SQLDMOScript_NonClusteredIndexes = 8192
SET @SQLDMOScript_Indexes = 73736
SET @SQLDMOScript_Aliases = 16384
SET @SQLDMOScript_NoCommandTerm = 32768
SET @SQLDMOScript_DRIIndexes = 65536
SET @SQLDMOScript_IncludeHeaders = 131072
SET @SQLDMOScript_OwnerQualify = 262144
SET @SQLDMOScript_TimestampToBinary = 524288
SET @SQLDMOScript_SortedData = 1048576
SET @SQLDMOScript_SortedDataReorg = 2097152
SET @SQLDMOScript_TransferDefault = 422143
SET @SQLDMOScript_DRI_NonClustered = 4194304
SET @SQLDMOScript_DRI_Clustered = 8388608
SET @SQLDMOScript_DRI_Checks = 16777216
SET @SQLDMOScript_DRI_Defaults = 33554432
SET @SQLDMOScript_DRI_UniqueKeys = 67108864
SET @SQLDMOScript_DRI_ForeignKeys = 134217728
SET @SQLDMOScript_DRI_PrimaryKey = 268435456
SET @SQLDMOScript_DRI_AllKeys = 469762048
SET @SQLDMOScript_DRI_AllConstraints = 520093696
SET @SQLDMOScript_DRI_All = 532676608
SET @SQLDMOScript_DRIWithNoCheck = 536870912
SET @SQLDMOScript_NoIdentity = 1073741824
SET @SQLDMOScript_UseQuotedIdentifiers = -1

-- SQLDMO_SCRIPT2_TYPE values
SET @SQLDMOScript2_Default = 0
SET @SQLDMOScript2_AnsiPadding = 1
SET @SQLDMOScript2_AnsiFile = 2
SET @SQLDMOScript2_UnicodeFile = 4
SET @SQLDMOScript2_NonStop = 8
SET @SQLDMOScript2_NoFG = 16
SET @SQLDMOScript2_MarkTriggers = 32
SET @SQLDMOScript2_OnlyUserTriggers = 64
SET @SQLDMOScript2_EncryptPWD = 128
SET @SQLDMOScript2_SeparateXPs = 256

DECLARE @dbname sysname,
	@sqlobject int,	-- SQL Server object
	@object int, 	-- Work variable for accessing COM objects
	@hr int, 	-- Contains HRESULT returned by COM
	@tfobject int 	-- Stores pointer to Transfer object

IF (@objectname='/?') GOTO Help

SET @resultset=UPPER(@resultset)

IF (@objectname IS NOT NULL) AND (CHARINDEX('%',@objectname)=0) AND (CHARINDEX('_',@objectname)=0) BEGIN
  SET @dbname=ISNULL(PARSENAME(@objectname,3),DB_NAME()) -- Extract the DB name; default to current
  SET @objectname=PARSENAME(@objectname,1)	-- Remove extraneous stuff from table name
  IF (@objectname IS NULL) BEGIN
     RAISERROR('Invalid object name.',16,1)
     RETURN -1
  END
  IF (@outputname IS NULL)
     SET @outputname=@objectname+'.SQL'
END ELSE BEGIN
  SET @dbname=DB_NAME()
  IF (@outputname IS NULL)  
    SET @outputname='GENERATED_SCRIPT.SQL'
END

-- Create a SQLServer object
EXEC @hr=sp_OACreate 'SQLDMO.SQLServer', @sqlobject OUTPUT
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @sqlobject, @hr
    RETURN
END

-- Create a Transfer object
EXEC @hr=sp_OACreate 'SQLDMO.Transfer', @tfobject OUTPUT 
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @tfobject, @hr
    RETURN
END

-- Set Transfer's CopyData property
EXEC @hr = sp_OASetProperty @tfobject, 'CopyData', 0
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @tfobject, @hr
    RETURN
END

-- Tell Transfer to copy the schema
EXEC @hr = sp_OASetProperty @tfobject, 'CopySchema', 1
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @tfobject, @hr
    RETURN
END

IF (@objectname IS NULL) BEGIN  -- Get all objects in the database

  -- Tell Transfer to copy all objects
  EXEC @hr = sp_OASetProperty @tfobject, 'CopyAllObjects', 1
  IF (@hr <> 0) BEGIN
      EXEC sp_displayoaerrorinfo @tfobject, @hr
      RETURN
  END

  -- Tell Transfer to get groups as well
  EXEC @hr = sp_OASetProperty @tfobject, 'IncludeGroups', 1
  IF (@hr <> 0) BEGIN
      EXEC sp_displayoaerrorinfo @tfobject, @hr
      RETURN
  END

  -- Tell it to include users
  EXEC @hr = sp_OASetProperty @tfobject, 'IncludeUsers', 1
  IF (@hr <> 0) BEGIN
      EXEC sp_displayoaerrorinfo @tfobject, @hr
      RETURN
  END

  -- Tell it to include logins
  EXEC @hr = sp_OASetProperty @tfobject, 'IncludeLogins', 1
  IF (@hr <> 0) BEGIN
      EXEC sp_displayoaerrorinfo @tfobject, @hr
      RETURN
  END

  -- Include object dependencies, too
  EXEC @hr = sp_OASetProperty @tfobject, 'IncludeDependencies', 1
  IF (@hr <> 0) BEGIN
      EXEC sp_displayoaerrorinfo @tfobject, @hr
      RETURN
  END

  IF (@scriptoptions IS NULL)  
    SET @scriptoptions=@SQLDMOScript_OwnerQualify | @SQLDMOScript_Default | @SQLDMOScript_Triggers |
               	@SQLDMOScript_Bindings | @SQLDMOScript_DatabasePermissions |
               	@SQLDMOScript_Permissions | @SQLDMOScript_ObjectPermissions | 
	       	@SQLDMOScript_ClusteredIndexes | @SQLDMOScript_Indexes | @SQLDMOScript_Aliases |
               	@SQLDMOScript_DRI_All | @SQLDMOScript_IncludeHeaders

END ELSE BEGIN
  DECLARE @obname sysname, 
	  @obtype varchar(2), 
	  @obowner sysname, 
	  @OBJECT_TYPES varchar(30), 
	  @obcode int

  -- Used to translate sysobjects.type into the bitmap that Transfer requires
  SET @OBJECT_TYPES='T     V  U  P     D  R  TR '

  -- Find all the objects that match the supplied mask and add them to Transfer's
  -- list of objects to script
  DECLARE ObjectList CURSOR FOR 
	SELECT name,type,USER_NAME(uid) FROM sysobjects 
	WHERE (name LIKE @objectname) 
    AND (CHARINDEX(type+' ',@OBJECT_TYPES)<>0)
    AND (OBJECTPROPERTY(id,'IsSystemTable')=0)
    AND (status>0)
	UNION ALL  -- Include user-defined data types
	SELECT name,'T',USER_NAME(uid) 
	FROM SYSTYPES 
	WHERE (usertype & 256)<>0
	AND (name LIKE @objectname)

  OPEN ObjectList

  FETCH ObjectList INTO @obname, @obtype, @obowner  WHILE (@@FETCH_STATUS=0) BEGIN
    SET @obcode=POWER(2,(CHARINDEX(@obtype+' ',@OBJECT_TYPES)/3))

    EXEC @hr = sp_OAMethod @tfobject, 'AddObjectByName', NULL, @obname, @obcode, @obowner
    IF (@hr <> 0) BEGIN
        EXEC sp_displayoaerrorinfo @tfobject, @hr
        RETURN
    END

    FETCH ObjectList INTO @obname, @obtype, @obowner  END
  CLOSE ObjectList
  DEALLOCATE ObjectList
  
  IF (@scriptoptions IS NULL)  
    SET @scriptoptions=@SQLDMOScript_Default  -- Keep it simple when not scripting the entire database
END

-- Set Transfer's ScriptType property
EXEC @hr = sp_OASetProperty @tfobject, 'ScriptType', @scriptoptions
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @tfobject, @hr
    RETURN
END

-- Connect to the server
IF (@password IS NOT NULL) AND (@password<>'')
  EXEC @hr = sp_OAMethod @sqlobject, 'Connect', NULL, @server, @username, @password
ELSE
  EXEC @hr = sp_OAMethod @sqlobject, 'Connect', NULL, @server, @username
IF (@hr <> 0) BEGIN
    EXEC sp_displayoaerrorinfo @sqlobject, @hr
    RETURN
END

-- Get a pointer to the SQLServer object's Databases collection
EXEC @hr = sp_OAGetProperty @sqlobject, 'Databases', @object OUT
IF @hr <> 0 BEGIN
    EXEC sp_displayoaerrorinfo @sqlobject, @hr
    RETURN
END

-- Get a pointer from the Databases collection for the specified database
EXEC @hr = sp_OAMethod @object, 'Item', @object OUT, @dbname
IF @hr <> 0 BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END

PRINT 'Ignore the code displayed below.  It''s a remnant of the SQL-DMO method used to produce
the script file'

DECLARE @rs CURSOR

-- Call the Database object's ScriptTransfer method to create the script
EXEC @hr = sp_OAMethod @object, 'ScriptTransfer',NULL, @tfobject, 2, @outputname
IF @hr <> 0 BEGIN
    EXEC sp_displayoaerrorinfo @object, @hr
    RETURN
END

EXEC sp_OADestroy @sqlobject  	-- For cleanliness
EXEC sp_OADestroy @tfobject	-- For cleanliness

IF (@resultset="YES") EXEC sp_readtextfile @outputname

RETURN 0

Help:
EXEC sp_usage @objectname='sp_generate_script',@desc='Generates a creation script for an object or collection of objects',
			@parameters='[@objectname="Object name or mask (defaults to all object in current database)"]
			[,@outputname="Output file name" (Default: @objectname+".SQL", or GENERATED_SCRIPT.SQL for entire database)]
			[,@scriptoptions=bitmask specifying script generation options]
			[,@server="server name"][, @username="user name"][, @password="password"]',
@author='Ken Henderson', @email='khen@khen.com',
@version='7', @revision='0',
@datecreated='19980401', @datelastchanged='19990702',
@example='sp_generate_script @objectname=''authors'', @outputname=''authors.sql'' '
RETURN -1

GO