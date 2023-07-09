set nocount on
CREATE TABLE #valueset (k1 int identity, c1 int)
INSERT #valueset (c1)  VALUES (20)
INSERT #valueset (c1)  VALUES (30)
INSERT #valueset (c1)  VALUES (40)
INSERT #valueset (c1)  VALUES (21)
INSERT #valueset (c1)  VALUES (31)
INSERT #valueset (c1)  VALUES (41)
INSERT #valueset (c1)  VALUES (22)
INSERT #valueset (c1)  VALUES (32)
INSERT #valueset (c1)  VALUES (42)

SELECT v.k1, SlidingAverage=AVG(1.0*a.c1)
FROM #valueset v CROSS JOIN #valueset a
WHERE (a.k1 BETWEEN v.k1-4 AND v.k1)
GROUP BY v.k1
GO
DROP TABLE #valueset
