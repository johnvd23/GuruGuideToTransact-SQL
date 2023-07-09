DECLARE @dbid int
SET @dbid=DB_ID('pubs')
DBCC FLUSHPROCINDB(@dbid)
