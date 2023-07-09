SET NOCOUNT ON
CREATE TABLE #set1 (col1 int, col2 int)
CREATE TABLE #set2 (col1 int, col2 int)

INSERT #set1 VALUES (1,1)
INSERT #set1 VALUES (1,1)
INSERT #set1 VALUES (2,2)
INSERT #set1 VALUES (3,3)
INSERT #set1 VALUES (4,4)
INSERT #set1 VALUES (5,5)

INSERT #set2 VALUES (1,1)
INSERT #set2 VALUES (2,2)
INSERT #set2 VALUES (2,2)
INSERT #set2 VALUES (5,5)

SELECT col1, col2
FROM (SELECT col1, 
	     col2, 
	     Num=COUNT(*)
      FROM #set1
      GROUP BY col1, col2
      UNION
      SELECT col1, 
	     col2, 
	     Num=COUNT(*)*-1
      FROM #set2
      GROUP BY col1, col2) s1
GROUP BY col1, col2
HAVING SUM(Num)<=0
GO
DROP TABLE #set1, #set2

