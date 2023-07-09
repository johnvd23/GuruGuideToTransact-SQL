SET NOCOUNT ON
CREATE TABLE #dist (k1 int, c1 int)
INSERT #dist VALUES (1,2)
INSERT #dist VALUES (2,2)
INSERT #dist VALUES (3,1)
INSERT #dist VALUES (4,4)
INSERT #dist VALUES (5,5)
INSERT #dist VALUES (6,7)
INSERT #dist VALUES (7,8)
INSERT #dist VALUES (8,9)

SELECT Median=AVG(DISTINCT 1.0*c1)
FROM (SELECT d1.c1
      FROM #dist d1 CROSS JOIN #dist d2
      GROUP BY d1.k1, d1.c1
      HAVING SUM(CASE WHEN d2.c1 = d1.c1 THEN 1 ELSE 0 END) >= 
      ABS(SUM(CASE WHEN d2.c1 < d1.c1 THEN 1 WHEN d2.c1 > d1.c1 THEN -1 ELSE 0 END))) d

GO
DROP TABLE #dist
