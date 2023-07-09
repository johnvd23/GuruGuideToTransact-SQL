SET NOCOUNT ON
CREATE TABLE #temp (k1 int identity PRIMARY KEY, c1 int NULL)

INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES

DECLARE c CURSOR KEYSET
FOR SELECT k1, c1 FROM #temp

OPEN c  -- The keyset is copied to tempdb

UPDATE #temp
SET c1=2
WHERE k1=1

INSERT #temp VALUES (3) -- won't be visible to cursor (can safely omit identity column)

FETCH c -- Change is visible
FETCH LAST FROM c -- New row isn't

SELECT * FROM #temp  

CLOSE c
DEALLOCATE c
GO
DROP TABLE #temp
