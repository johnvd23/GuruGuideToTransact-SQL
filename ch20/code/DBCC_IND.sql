DECLARE @dbid int, @objid int
SELECT @dbid=DB_ID('pubs'), @objid=OBJECT_ID('pubs..authors')
DBCC TRACEON(3604) 
DBCC IND(@dbid,@objid, 1)
DBCC TRACEOFF(3604) 
