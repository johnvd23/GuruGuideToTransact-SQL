SET NOCOUNT ON
CREATE TABLE #valueset (k1 int, c1 int)
INSERT #valueset VALUES (1,20)
INSERT #valueset VALUES (1,21)
INSERT #valueset VALUES (1,22)
INSERT #valueset VALUES (1,24)
INSERT #valueset VALUES (1,28)
INSERT #valueset VALUES (2,31)
INSERT #valueset VALUES (2,32)
INSERT #valueset VALUES (2,40)
INSERT #valueset VALUES (2,41)
INSERT #valueset VALUES (3,52)
INSERT #valueset VALUES (3,53)
INSERT #valueset VALUES (3,56)
INSERT #valueset VALUES (3,58)
INSERT #valueset VALUES (3,59)
INSERT #valueset VALUES (4,60)
INSERT #valueset VALUES (4,61)
INSERT #valueset VALUES (4,62)

SELECT v.k1, v.c1
FROM #valueset v JOIN #valueset a ON (v.k1=a.k1)
GROUP BY v.k1, v.c1
HAVING COUNT(CASE WHEN a.c1 <= v.c1 THEN 1 ELSE null END) BETWEEN (COUNT(*)/4) AND (COUNT(*)/4)*2
GO
DROP TABLE #valueset
