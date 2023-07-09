-- This code creates a cursor that exhibits the Halloween Problem.  
-- Don't run it unless you find infinite loops intriguing.
SET NOCOUNT ON
CREATE TABLE #temp (k1 int identity, c1 int NULL)
CREATE CLUSTERED INDEX c1 ON #temp(c1)

INSERT #temp VALUES (8)
INSERT #temp VALUES (6)
INSERT #temp VALUES (7)
INSERT #temp VALUES (5)
INSERT #temp VALUES (3)
INSERT #temp VALUES (0)
INSERT #temp VALUES (9)

DECLARE c CURSOR DYNAMIC
FOR SELECT k1, c1 FROM #temp

OPEN c

FETCH c

WHILE (@@FETCH_STATUS=0) BEGIN
  UPDATE #temp
  SET c1=c1+1
  WHERE CURRENT OF c
  FETCH c
  SELECT * FROM #temp ORDER BY k1
END


CLOSE c
DEALLOCATE c
GO
DROP TABLE #temp
