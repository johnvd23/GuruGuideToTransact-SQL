SET NOCOUNT ON
CREATE TABLE #valueset (k1 int identity, c1 int)
INSERT #valueset (c1) VALUES (20)
INSERT #valueset (c1) VALUES (30)
INSERT #valueset (c1) VALUES (0)
INSERT #valueset (c1) VALUES (0)
INSERT #valueset (c1) VALUES (0)
INSERT #valueset (c1) VALUES (41)
INSERT #valueset (c1) VALUES (0)
INSERT #valueset (c1) VALUES (32)
INSERT #valueset (c1) VALUES (42)

SELECT v.k1
FROM #valueset v JOIN #valueset a 
ON (v.c1=0) AND (a.c1=0) AND (ABS(a.k1-v.k1)=1)
GROUP BY v.k1
GO
DROP TABLE #valueset
