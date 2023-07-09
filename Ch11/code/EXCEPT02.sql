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
INSERT #set2 VALUES (5,5)
INSERT #set2 VALUES (5,5)

SELECT col1, col2
FROM (SELECT col1, 
	     col2, 
	     Num1=COUNT(*),
	     Num2=(SELECT COUNT(*) FROM #set2 ss2 WHERE col1=ss1.col1 AND col2=ss1.col2) 
      FROM #set1 ss1
      GROUP BY col1, col2) s1
GROUP BY col1, col2
HAVING (ABS(SUM(Num1)-SUM(Num2))>0) 
GO
DROP TABLE #set1, #set2

