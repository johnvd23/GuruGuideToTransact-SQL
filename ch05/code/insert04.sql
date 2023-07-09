CREATE TABLE #sp_who
(spid		int,
 status		varchar(30),
 loginame	sysname,
 hostname	sysname,
 blk		int,
 dbname		sysname,
 cmd		varchar(16))

INSERT #sp_who
EXEC sp_who

SELECT * FROM #sp_who
GO
DROP TABLE #sp_who
