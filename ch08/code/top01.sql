SET NOCOUNT ON
CREATE TABLE #valueset (c1 int)
INSERT #valueset VALUES (2)
INSERT #valueset VALUES (3)
INSERT #valueset VALUES (1)
INSERT #valueset VALUES (4)
INSERT #valueset VALUES (8)
INSERT #valueset VALUES (9)

SELECT v.c1
FROM #valueset v CROSS JOIN #valueset a
GROUP BY v.c1
HAVING COUNT(CASE WHEN a.c1 <=v.c1 THEN 1 ELSE NULL END) > COUNT(*)-3

DROP TABLE #valueset
