set nocount on
CREATE TABLE #dist (c1 int)
INSERT #dist VALUES (2)
INSERT #dist VALUES (2)
INSERT #dist VALUES (1)
INSERT #dist VALUES (5)
INSERT #dist VALUES (5)
INSERT #dist VALUES (9)

SELECT Median=ISNULL((CASE WHEN COUNT(CASE WHEN i.c1<=d.c1 THEN 1 ELSE NULL END) > (COUNT(*)+1)/2 THEN 1.0*d.c1 ELSE NULL END)+COUNT(*)%2,
              (d.c1+MIN((CASE WHEN i.c1>d.c1 THEN i.c1 ELSE NULL END)))/2.0)
FROM #dist d CROSS JOIN #dist i
GROUP BY d.c1
HAVING (COUNT(CASE WHEN i.c1 <= d.c1 THEN 1 ELSE NULL END)>=(COUNT(*)+1)/2)
AND (COUNT(CASE WHEN i.c1 >=d.c1 THEN 1 ELSE NULL END) >= COUNT(*)/2+1)
GO
drop table #dist