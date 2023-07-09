DECLARE c CURSOR FOR 
SELECT 
	TableName=OBJECT_NAME(id), 
	IndexName=name, 
	StatsUpdated=STATS_DATE(id, indid)
FROM sysindexes
WHERE 
OBJECTPROPERTY(id,'IsSystemTable')=0 
AND indid>0
AND indid<255

DECLARE @tname varchar(30),
	@iname varchar(30),
	@dateupd datetime

OPEN c
FETCH c INTO @tname, @iname, @dateupd

WHILE (@@FETCH_STATUS=0) BEGIN
  IF (SELECT DATEDIFF(dd,ISNULL(@dateupd,'19000101'),GETDATE()))>30 BEGIN
    PRINT 'UPDATE STATISTICS '+@tname+' '+@iname
    EXEC('UPDATE STATISTICS '+@tname+' '+@iname)
  END
  FETCH c INTO @tname, @iname, @dateupd
END

CLOSE c
DEALLOCATE c
