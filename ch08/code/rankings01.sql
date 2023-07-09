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

SELECT * FROM #rankings ORDER BY Ranking
DROP TABLE #rankings
go

DROP TABLE #valueset
