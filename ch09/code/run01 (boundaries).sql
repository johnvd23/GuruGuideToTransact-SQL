SET NOCOUNT ON
CREATE TABLE #valueset (k1 int, c1 int)
INSERT #valueset VALUES (2,20)
INSERT #valueset VALUES (3,30)
INSERT #valueset VALUES (5,0)
INSERT #valueset VALUES (9,0)
INSERT #valueset VALUES (10,0)
INSERT #valueset VALUES (11,40)
INSERT #valueset VALUES (13,0)
INSERT #valueset VALUES (15,0)
INSERT #valueset VALUES (16,42)

SELECT StartRun=v.k1, EndRun=a.k1
FROM #valueset v JOIN #valueset a ON (v.k1 < a.k1) CROSS JOIN #valueset l 
GROUP BY v.k1, a.k1
HAVING (SUM(ABS(l.c1)*(CASE WHEN v.k1 <=l.k1 AND l.k1 <= a.k1 THEN 1 ELSE 0 END))=0)
AND (ISNULL(MIN(CASE WHEN l.k1 > a.k1 THEN (2*(l.k1-a.k1))+(CASE WHEN l.c1<>0 THEN 1 ELSE 0 END) ELSE null END),1)%2 != 0)
AND (ISNULL(MIN(CASE WHEN l.k1 < v.k1 THEN (2*(v.k1-l.k1))+(CASE WHEN l.c1<>0 THEN 1 ELSE 0 END) ELSE null END),1)%2 != 0)
GO
DROP TABLE #valueset
