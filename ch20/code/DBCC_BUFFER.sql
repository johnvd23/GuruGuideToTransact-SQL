DBCC TRACEON(3604) 
GO
DECLARE @dbid int, @objid int
SELECT @dbid=DB_ID('pubs'), @objid=OBJECT_ID('pubs..titles')
SELECT COUNT(*) FROM pubs..titles -- Load up the buffers
DBCC BUFFER(@dbid,@objid,1,2)
GO
DBCC TRACEOFF(3604) 
GO
