SET NOCOUNT ON
CREATE TABLE #valueset (c1 int)
INSERT #valueset VALUES (2)
INSERT #valueset VALUES (2)  -- Duplicate value
INSERT #valueset VALUES (1)
INSERT #valueset VALUES (3)
INSERT #valueset VALUES (4)
INSERT #valueset VALUES (4)  -- Duplicate value
INSERT #valueset VALUES (11)  
INSERT #valueset VALUES (11) -- Duplicate value
INSERT #valueset VALUES (13)

SELECT Ranking=IDENTITY(int), c1
INTO #rankings
FROM #valueset
WHERE 1=2  -- Create an empty table

INSERT #rankings (c1)
SELECT c1
FROM #valueset
ORDER BY c1 DESC

SELECT a.Ranking, Ties=CAST(LEFT(CAST(a.NumWithValue AS varchar)+'-Way tie',NULLIF(a.NumWithValue,1)*11) AS CHAR(11)), r.c1 
FROM 
  (SELECT Ranking=MIN(n.Ranking), NumWithValue=COUNT(*), n.c1 FROM #rankings n GROUP BY n.c1) a,
  #rankings r
WHERE r.c1=a.c1
ORDER BY a.ranking
DROP TABLE #rankings
go

DROP TABLE #valueset
