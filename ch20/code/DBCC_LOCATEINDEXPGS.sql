DECLARE @dbid int, @pagebin varchar(12), @pageid int, @fileid int, @objid int
SELECT TOP 1 @dbid=DB_ID('pubs'), @objid=id, @pagebin=first FROM sysindexes WHERE id=OBJECT_ID('authors')
EXEC sp_decodepagebin @pagebin, @fileid OUT, @pageid OUT
DBCC TRACEON(3604) 
DBCC LOCATEINDEXPGS(@dbid, @objid, @pageid, 1, 0)
DBCC TRACEOFF(3604) 
