DBCC TRACEON(3604)
GO
DECLARE @dbid int, @objid int
SELECT @dbid=DB_ID('pubs'), @objid=OBJECT_ID('titles')
DBCC BCPTABLOCK(@dbid,@objid,1)
GO
DBCC TRACEOFF(3604)
GO
checkpoint
go
exec sp_tableoption 'titles'
