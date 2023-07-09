SET NOCOUNT ON
CREATE TABLE #valueset (c1 int)
INSERT #valueset VALUES (20)
INSERT #valueset VALUES (30)
INSERT #valueset VALUES (40)
INSERT #valueset VALUES (21)
INSERT #valueset VALUES (31)
INSERT #valueset VALUES (41)
INSERT #valueset VALUES (22)
INSERT #valueset VALUES (32)
INSERT #valueset VALUES (42)

SELECT v.c1
FROM #valueset v CROSS JOIN #valueset a
GROUP BY v.c1
HAVING COUNT(CASE WHEN a.c1 <= v.c1 THEN 1 ELSE null END)%(COUNT(*)/3)=1
GO
DROP TABLE #valueset
