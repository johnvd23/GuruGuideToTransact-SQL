USE master
GO
IF OBJECT_ID('dbo.sp_object_script_comments') IS NOT NULL
  DROP PROC dbo.sp_object_script_comments
GO
CREATE PROCEDURE dbo.sp_object_script_comments 
			  -- Required parameters
			  @objectname sysname=NULL,
			  @desc sysname=NULL,

			  -- Optional parameters
			  @parameters varchar(8000)=NULL,
			  @example varchar(8000)=NULL,
			  @author sysname=NULL,
			  @email sysname='(none)',
	  		  @version sysname=NULL,
			  @revision sysname='0',
			  @datecreated smalldatetime=NULL,
			  @datelastchanged smalldatetime=NULL
/*

Object: sp_object_script_comments
Description: Generates comment headers for object-creation SQL scripts
Usage: sp_object_script_comments @objectname="ObjectName", @desc="Description of object",@parameters="param1[,param2...]"
Created by: Ken Henderson. Email: khen@khen.com
Version: 3.1
Example usage: sp_object_script_comments @objectname="sp_who", @desc="Returns a list of currently running jobs", @parameters=[@loginname]
Created: 1992-04-03.  Last changed: 1999-07-01 01:13:00.
*/
AS

IF (@objectname+@desc) IS NULL GOTO Help

PRINT '/*'
PRINT CHAR(13)
EXEC sp_usage @objectname=@objectname,
		@desc=@desc,
  	   	@parameters=@parameters,
		@example=@example,
		@author=@author,
		@email=@email,
		@version=@version, @revision=@revision,
		@datecreated=@datecreated, @datelastchanged=@datelastchanged
PRINT CHAR(13)+'*/'

RETURN 0

Help:
EXEC sp_usage @objectname='sp_object_script_comments',
	@desc='Generates comment headers for SQL scripts',
   	@parameters='@objectname="ObjectName", @desc="Description of object",@parameters="param1[,param2...]"',
	@example='sp_object_script_comments @objectname="sp_who", @desc="Returns a list of currently running jobs", @parameters=[@loginname]',
	@author='Ken Henderson',
	@email='khen@khen.com',
	@version='3', @revision='1',
	@datecreated='19920403', @datelastchanged='19990701'
RETURN -1

