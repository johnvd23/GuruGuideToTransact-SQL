SET NOCOUNT ON
CREATE TABLE #series
(key1 int,
 key2 int,
 value1 decimal(6,2) DEFAULT (
(CASE (CAST(RAND()+.5 AS int)*-1) WHEN 0 THEN 1 ELSE -1 END)*(CONVERT(int, RAND() * 100000) % 10000)*RAND()
)
)

INSERT #series (key1, key2) VALUES (1,1)
INSERT #series (key1, key2) VALUES (1,2)
INSERT #series (key1, key2) VALUES (1,3)
INSERT #series (key1, key2) VALUES (1,4)
INSERT #series (key1, key2) VALUES (1,5)
INSERT #series (key1, key2) VALUES (1,6)
INSERT #series (key1, key2) VALUES (2,1)
INSERT #series (key1, key2) VALUES (2,2)
INSERT #series (key1, key2) VALUES (2,3)
INSERT #series (key1, key2) VALUES (2,4)
INSERT #series (key1, key2) VALUES (2,5)
INSERT #series (key1, key2) VALUES (2,6)
INSERT #series (key1, key2) VALUES (2,7)
INSERT #series (key1, key2) VALUES (3,1)
INSERT #series (key1, key2) VALUES (3,2)
INSERT #series (key1, key2) VALUES (3,3)

DECLARE s CURSOR
FOR 
SELECT DISTINCT key2 FROM #series ORDER BY key2

DECLARE @key2 int, @key2str varchar(10), @sql varchar(8000)
SET @sql=''

OPEN s
FETCH s INTO @key2

WHILE (@@FETCH_STATUS=0) BEGIN
  SET @key2str=CAST(@key2 AS varchar)
  SET @sql=@sql+',CASE WHEN key2='+@key2str+' THEN value1 ELSE NULL END ['+@key2str+']'
  FETCH s INTO @key2
END

SET @sql='SELECT key1'+@sql+' FROM #series' -- GROUP BY key1'
EXEC(@sql)

CLOSE s
DEALLOCATE s
DROP TABLE #series