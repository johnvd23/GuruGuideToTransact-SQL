SET NOCOUNT ON
CREATE TABLE #valueset(k1 int identity, c1 int)
INSERT #valueset(c1) VALUES (20)
INSERT #valueset(c1) VALUES (30)
INSERT #valueset(c1) VALUES (32)
INSERT #valueset(c1) VALUES (34)
INSERT #valueset(c1) VALUES (36)
INSERT #valueset(c1) VALUES (0)
INSERT #valueset(c1) VALUES (0)
INSERT #valueset(c1) VALUES (41)
INSERT #valueset(c1) VALUES (0)
INSERT #valueset(c1) VALUES (0)
INSERT #valueset(c1) VALUES (0)
INSERT #valueset(c1) VALUES (42)

SELECT RegionStart=v.k1,RegionEnd=ISNULL(MIN(CASE WHEN a.k1>v.k1 AND a.c1 !=0 THEN a.k1 ELSE null END)-1,
         MAX(CASE WHEN a.k1 > v.k1 THEN a.k1 ELSE v.k1 END))
FROM #valueset v JOIN #valueset a ON (v.c1=0)
GROUP BY v.k1
HAVING
  ISNULL(MIN(CASE WHEN a.k1>v.k1 AND a.c1 !=0 THEN a.k1 ELSE null END)-1,
         MAX(CASE WHEN a.k1 > v.k1 THEN a.k1 ELSE v.k1 END)) > v.k1
AND 
  ISNULL(MAX(CASE WHEN a.k1<v.k1 AND a.c1 !=0 THEN a.k1 ELSE null END)+1,
         MIN(CASE WHEN a.k1 < v.k1 THEN a.k1 ELSE v.k1 END)) = v.k1
GO
DROP TABLE #valueset
