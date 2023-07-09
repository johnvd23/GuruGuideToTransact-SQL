USE master
GO
IF OBJECT_ID('sp_lock_verbose') IS NOT NULL
  DROP PROC sp_lock_verbose
GO
CREATE PROC sp_lock_verbose @spid1 varchar(10)=NULL, @spid2 varchar(10)=NULL
/*

Object: sp_lock_verbose
Description: A more verbose version of sp_lock
Usage: sp_lock_verbose [@spid1=first spid to check][,@spid2=second spid to check]
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 4.2
Example usage: sp_lock_verbose 18,25 -- checks spid's 18 and 25
Created: 1994-11-18.  Last changed: 1999-06-01.
*/
AS
SET NOCOUNT ON

IF (@spid1='/?') GOTO Help

DECLARE @dbid varchar(20), @dbname sysname, @objname sysname, @objid int, @execstr varchar(8000), @nexecstr nvarchar(4000)

CREATE TABLE #locks (spid int, dbid int, objid int, objectname sysname NULL, indid int, type char(4), resource char(15), mode char(10), status char(6))

-- Get basic locking info from sp_lock
INSERT #locks (spid, dbid, objid, indid, type, resource, mode, status)
EXEC sp_lock @spid1, @spid2

-- Loop through the work table and translate each object id into an object name
DECLARE DBs CURSOR FOR SELECT DISTINCT dbid=CAST(dbid AS varchar) FROM #locks
OPEN DBs
FETCH DBs INTO @dbid
WHILE (@@FETCH_STATUS=0) BEGIN
	SET @dbname=DB_NAME(@dbid)
	EXEC master..xp_sprintf @execstr OUTPUT, 'UPDATE #locks SET objectname=o.name FROM %s..sysobjects o WHERE (#locks.type=''TAB'' OR #locks.type=''PAG'') AND dbid=%s AND #locks.objid=o.id', @dbname, @dbid
        EXEC(@execstr)
	EXEC master..xp_sprintf @execstr OUTPUT, 'UPDATE #locks SET objectname=i.name FROM %s..sysindexes i WHERE (#locks.type=''IDX'' OR #locks.type=''KEY'') AND dbid=%s AND #locks.objid=i.id AND #locks.indid=i.indid', @dbname, @dbid
        EXEC(@execstr)
	EXEC master..xp_sprintf @execstr OUTPUT, 'UPDATE #locks SET objectname=f.name FROM %s..sysfiles f WHERE #locks.type=''FIL'' AND dbid=%s AND #locks.objid=f.fileid', @dbname, @dbid
        EXEC(@execstr)
	FETCH DBs INTO @dbid
END
CLOSE DBs
DEALLOCATE DBs

-- Return the result set
SELECT login=LEFT(p.loginame,20), db=LEFT(DB_NAME(l.dbid),30), l.type, object=CASE WHEN l.type='DB' THEN LEFT(DB_NAME(l.dbid),30) ELSE LEFT(objectname,30) END, l.resource, l.mode, l.status, l.objid, l.indid, l.spid
FROM #locks l JOIN sysprocesses p ON (l.spid=p.spid)
ORDER BY 1,2,3,4,5,6,7

DROP TABLE #locks

RETURN 0

Help:
EXEC sp_usage @objectname='sp_lock_verbose', @desc='A more verbose version of sp_lock',
@parameters='[@spid1=first spid to check][,@spid2=second spid to check]',
@author='Ken Henderson',@email='khen@khen.com',
@version='4',@revision='2',
@datecreated='19941118', @datelastchanged='19990601',
@example="sp_lock_verbose 18,25 -- checks spid's 18 and 25"
RETURN -1

GO
