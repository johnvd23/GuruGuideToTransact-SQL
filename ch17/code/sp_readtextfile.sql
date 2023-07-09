USE master
GO
IF OBJECT_ID('sp_readtextfile') IS NOT NULL
  DROP PROC sp_readtextfile
GO
CREATE PROC sp_readtextfile @textfilename sysname
/*

Object: sp_readtextfile
Description: Reads the contents of a text file into a SQL result set
Usage: sp_readtextfile @textfilename=name of file to read
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 7.0
Example: sp_readtextfile 'D:\MSSQL7\LOGS\errorlog' 
Created: 1996-05-01.  Last changed: 1999-06-14.

NOTE:

There’s a bug in the shipping version of SQL 7.0 that prevents sp_readtext from being 
called by routines that use the OLE Automation sp_OAxxxx procedures.  Sp_readtext uses 
the Transact-SQL BULK INSERT command to load its textfile into a temporary table, which 
it then returns as a result set.  BULK INSERT is marked as a free threaded OLE provider.  
With the ODSOLE facility (the sp_OAxxxx procedures), COM is initialized using the single 
apartment model.  When BULK INSERT is called by a thread already initialized as a single 
apartment, the conflict between the two models causes the instantiation of the OLE-DB 
Stream provider to fail – BULK INSERT can’t read the operating system file that’s been 
passed to it.

The workaround requires modifying the system registry.  Follow these steps to allow BULK 
INSERT to be called from procedures and scripts using the single apartment COM model:

1. Run regedit.exe or regedt32.exe
2. Drill down into 
   HKEY_CLASSES_ROOT\CLSID\{F3A18EEA-D34B-11d2-88D7-00C04F68DC44}\InprocServer32\ThreadingModel
3. Replace "Free" with "Both" (omit quotes)

*/
AS
SET NOCOUNT ON

IF (@textfilename='/?') GOTO Help

CREATE TABLE #lines (line varchar(8000))

EXEC('BULK INSERT #lines FROM "'+@textfilename+'"')

SELECT * FROM #lines

DROP TABLE #lines
RETURN 0

Help:
EXEC sp_usage @objectname='sp_readtextfile', 
@desc='Reads the contents of a text file into a SQL result set',
@parameters='@textfilename=name of file to read',
@author='Ken Henderson', @email='khen@khen.com',
@version='7',@revision='0',
@datecreated='19960501', @datelastchanged='19990614',
@example='sp_readtextfile ''D:\MSSQL7\LOGS\errorlog'' '
RETURN -1
