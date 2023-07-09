USE pubs
GO
DBCC TRACEON(3604) 
GO
DECLARE @dbid int, @objid int
SELECT @dbid=DB_ID('pubs'), @objid=OBJECT_ID('authors')
DBCC DES(@dbid, @objid)
GO
DBCC TRACEOFF(3604) 
GO
