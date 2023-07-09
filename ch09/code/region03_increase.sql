SET NOCOUNT ON
CREATE TABLE #valueset (k1 int, c1 int)
INSERT #valueset (k1, c1) VALUES (300,15)
INSERT #valueset (k1, c1) VALUES (340,25)
INSERT #valueset (k1, c1) VALUES (344,13)
INSERT #valueset (k1, c1) VALUES (345,14)
INSERT #valueset (k1, c1) VALUES (346,15)
INSERT #valueset (k1, c1) VALUES (347,38)
INSERT #valueset (k1, c1) VALUES (348,16)

SELECT v.k1, v.c1
FROM #valueset v JOIN #valueset a 
ON ((a.c1 = v.c1+1) AND (a.k1 = v.k1+1))
OR ((a.c1 = v.c1-1) AND (a.k1 = v.k1-1))
GROUP BY v.k1, v.c1
GO
DROP TABLE #valueset
