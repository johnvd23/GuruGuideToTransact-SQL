DECLARE @dbid int, @pagebin varchar(12), @pageid int, @fileid int, @objid int
SELECT TOP 1 @dbid=DB_ID('pubs'), @objid=id, @pagebin=first FROM pubs..sysindexes WHERE id=OBJECT_ID('pubs..authors')
EXEC sp_decodepagebin @pagebin, @fileid OUT, @pageid OUT
DBCC TRACEON(3604) 
DBCC PRTIPAGE(@dbid, @objid, 2, @pageid)
DBCC TRACEOFF(3604) 
