SET NOCOUNT ON
CREATE TABLE #valueset (c1 int)
INSERT #valueset VALUES (2)
INSERT #valueset VALUES (2)  -- Duplicate value
INSERT #valueset VALUES (1)
INSERT #valueset VALUES (3)
INSERT #valueset VALUES (4)
INSERT #valueset VALUES (4)  -- Duplicate value
INSERT #valueset VALUES (10)
INSERT #valueset VALUES (11)
INSERT #valueset VALUES (13)

SELECT l.c1
FROM (SELECT ranking=(SELECT COUNT(DISTINCT a.c1) FROM #valueset a WHERE v.c1 >= a.c1),
             v.c1 
      FROM #valueset v) l
WHERE l.ranking <=3
ORDER BY l.ranking
go

DROP TABLE #valueset
