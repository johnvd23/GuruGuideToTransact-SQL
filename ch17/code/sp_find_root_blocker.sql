USE master
GO
IF OBJECT_ID('sp_find_root_blocker') IS NOT NULL
  DROP PROC sp_find_root_blocker
GO

CREATE PROCEDURE sp_find_root_blocker @help char(2)=NULL
/*
Object: sp_find_root_blocker
Description: Finds the root offender(s) in the chain(s) of blocked processes
Usage: sp_find_root_blocker 
Returns: spid of the root blocking process (returns the last one if there are multiple)
Created by: Ken Henderson. Email: khen@khen.com
Version: 6.0
Example: sp_find_root_blocker
Created: 1992-11-03.  Last changed: 1999-07-05.
*/
AS
IF (@help='/?') GOTO Help

IF EXISTS (SELECT * FROM master..sysprocesses p1 JOIN master..sysprocesses p2 ON (p1.spid=p2.blocked)) BEGIN
  DECLARE @spid int

  SELECT @spid=p1.spid  -- Get the _last_ prime offender
  FROM master..sysprocesses p1 JOIN master..sysprocesses p2 ON (p1.spid=p2.blocked)
  WHERE p1.blocked=0

  SELECT	p1.spid, 
	  	p1.status, 
		loginame=LEFT(p1.loginame,20), 
 		hostname=substring(p1.hostname,1,20),
            	blk=CONVERT(char(3),p1.blocked),
        	db=LEFT(db_name(p1.dbid),10),
		p1.cmd, 
		p1.waittype
    FROM master..sysprocesses p1 JOIN master..sysprocesses p2 ON (p1.spid=p2.blocked)
    WHERE p1.blocked=0
  RETURN(@spid)  -- Return the last root blocker
END ELSE BEGIN
  PRINT 'No processes are currently blocking others.'
  RETURN(0)
END

RETURN 0

Help:
EXEC sp_usage @objectname='sp_find_root_blocker', @desc='Finds the root offender(s) in the chain(s) of blocked processes',
@parameters='', @returns='spid of the root blocking process (returns the last one if there are multiple)',
@author='Ken Henderson', @email='khen@khen.com',
@version='6', @revision='0',
@datecreated='19921103', @datelastchanged='19990705',
@example='sp_find_root_blocker'

RETURN -1

GO

