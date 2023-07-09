SET NOCOUNT ON
CREATE TABLE #valueset (k1 int, c1 int)
INSERT #valueset VALUES (2,0)
INSERT #valueset VALUES (3,30)
INSERT #valueset VALUES (5,0)
INSERT #valueset VALUES (9,0)
INSERT #valueset VALUES (10,0)
INSERT #valueset VALUES (11,40)
INSERT #valueset VALUES (13,0)
INSERT #valueset VALUES (14,0)
INSERT #valueset VALUES (15,42)

SELECT v.k1
FROM #valueset v JOIN #valueset a ON (v.c1=0)
GROUP BY v.k1
HAVING (MIN(CASE WHEN a.k1 > v.k1 THEN (2*(a.k1-v.k1))+CASE WHEN a.c1<>0 THEN 1 ELSE 0 END ELSE null END)%2=0)
OR (MIN(CASE WHEN a.k1 < v.k1 THEN (2*(v.k1-a.k1))+CASE WHEN a.c1<>0 THEN 1 ELSE 0 END ELSE null END)%2=0)
GO
DROP TABLE #valueset
