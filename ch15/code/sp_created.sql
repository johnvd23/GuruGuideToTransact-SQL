USE master
IF OBJECT_ID('dbo.sp_created') IS NOT NULL
  DROP PROC dbo.sp_created
GO
CREATE PROC dbo.sp_created @objname sysname=NULL
/*
Object: sp_created
Description: Lists the creation date(s) for the specified object(s)
Usage: sp_created @objname="Object name or mask you want to display"
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 1.0
Example: sp_created @objname="myprocs%"
Created: 1999-08-01.  Last changed: 1999-08-15.
*/
AS
IF (@objname IS NULL) or (@objname='/?') GOTO Help
SELECT name, crdate FROM sysobjects
WHERE name like @objname
RETURN 0

Help:
EXEC sp_usage @objectname='sp_created',
	@desc='Lists the creation date(s) for the specified object(s)',
   	@parameters='@objname="Object name or mask you want to display"',
	@example='sp_created @objname="myprocs%"',
	@author='Ken Henderson',
	@email='khen@khen.com',
	@version='1', @revision='0',
	@datecreated='19990801', @datelastchanged='19990815'
RETURN -1
