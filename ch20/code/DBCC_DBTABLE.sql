DBCC TRACEON(3604) 
GO
DECLARE @dbid int
SET @dbid=DB_ID('pubs')
DBCC DBTABLE(@dbid)
GO
DBCC TRACEOFF(3604) 
GO
