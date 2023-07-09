set nocount on
CREATE TABLE #dist (c1 int)
INSERT #dist VALUES (2)
INSERT #dist VALUES (3)
INSERT #dist VALUES (1)
INSERT #dist VALUES (3)  -- Dup value
INSERT #dist VALUES (8)
INSERT #dist VALUES (9)

SELECT d.c1
FROM #dist d CROSS JOIN #dist i
GROUP BY d.c1
HAVING (COUNT(CASE WHEN i.c1 <= d.c1 THEN 1 ELSE NULL END)>=(COUNT(*)+1)/2)
AND (COUNT(CASE WHEN i.c1 >=d.c1 THEN 1 ELSE NULL END) >= COUNT(*)/2+1)

DROP TABLE #dist