SET NOCOUNT ON
CREATE TABLE #temp (k1 int identity, c1 int NULL)

INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES

DECLARE c CURSOR STATIC
FOR SELECT k1, c1 FROM #temp

OPEN c  -- The entire result set is copied to tempdb

UPDATE #temp
SET c1=2
WHERE k1=1

FETCH c  -- This doesn't reflect the changed made by the UPDATE

SELECT * FROM #temp  -- But the change is indeed there

CLOSE c
DEALLOCATE c
GO
DROP TABLE #temp
