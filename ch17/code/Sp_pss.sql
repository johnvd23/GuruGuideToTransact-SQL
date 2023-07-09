USE master
GO
IF OBJECT_ID('sp_pss') IS NOT NULL
  DROP PROC SP_PSS
GO
CREATE PROC sp_pss
	@spid varchar(10)='%',
	@buffersonly varchar(3)='NO'
/*
Object: sp_pss
Description: Lists detail info for running processes
Usage: sp_pss [@spid=process id to list] (Defaults to all processes)[,@buffersonly=YES|NO] - 
determines whether the report is limited to the input/output buffers for each process
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 4.2
Example usage: sp_pss 8
Created: 1991-01-28.  Last changed: 1999-06-02.
*/
AS
SET NOCOUNT ON

IF (@spid='/?') OR NOT EXISTS(SELECT * FROM master..sysprocesses WHERE spid LIKE @spid) GOTO Help

SET @buffersonly=UPPER(@buffersonly)

DECLARE @sp int, @lname sysname

DECLARE Processes CURSOR 
FOR SELECT spid, loginame FROM master..sysprocesses
WHERE spid LIKE @spid 
AND HostProcess IS NOT NULL
AND HostProcess <> ''

OPEN Processes

DBCC TRACEON(3604)

FETCH Processes INTO @sp, @lname
WHILE (@@FETCH_STATUS=0) BEGIN
  IF (@buffersonly='NO') BEGIN
    PRINT CHAR(13)+'Retrieving PSS info for spid: '+CAST(@sp AS varchar)+' user: '+@lname
    DBCC PSS(0,@sp)
  END ELSE BEGIN
    PRINT CHAR(13)+'Retrieving the input buffer for spid: '+CAST(@sp AS varchar)+' user: '+@lname
    PRINT CHAR(13)
    DBCC INPUTBUFFER(@sp)
    PRINT CHAR(13)+'Retrieving the output buffer for spid: '+CAST(@sp AS varchar)+' user: '+@lname
    PRINT CHAR(13)
    DBCC OUTPUTBUFFER(@sp)
  END
  FETCH Processes INTO @sp, @lname
END

DBCC TRACEOFF(3604)

CLOSE Processes
DEALLOCATE Processes
RETURN 0

Help:
EXEC sp_usage @objectname='sp_pss',@desc='Lists detail info for running processes',
	@parameters='[@spid=process id to list] (Defaults to all processes)[,@buffersonly=YES|NO] - 
determines whether the report is limited to the input/output buffers for each process',
	@author='Ken Henderson', @email='khen@khen.com',
	@version='4', @revision='2',
	@example='sp_pss 8
sp_pss @buffersonly="YES"',
	@datecreated='19910128', @datelastchanged='19990602'
RETURN -1

GO
