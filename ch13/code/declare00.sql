SET NOCOUNT ON
CREATE TABLE #temp (k1 int identity, c1 int NULL)

INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES

DECLARE @k1 int

DECLARE c CURSOR
FOR SELECT k1, c1 FROM #temp WHERE k1<@k1 -- Won't work -- @k1 is NULL here

SET @k1=3 -- Need to move this before the DECLARE CURSOR
OPEN c
FETCH c

UPDATE #temp
SET c1=2
WHERE CURRENT OF c

SELECT * FROM #temp
CLOSE c
DEALLOCATE c
GO
DROP TABLE #temp
