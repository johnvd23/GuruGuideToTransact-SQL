SET NOCOUNT ON
CREATE TABLE #set1 (col1 int, col2 int)
CREATE TABLE #set2 (col1 int, col2 int)

INSERT #set1 VALUES (1,1)
INSERT #set1 VALUES (2,2)
INSERT #set1 VALUES (3,3)
INSERT #set1 VALUES (4,4)
INSERT #set1 VALUES (5,5)

INSERT #set2 VALUES (1,1)
INSERT #set2 VALUES (2,2)
INSERT #set2 VALUES (5,5)

SELECT s1.* 
FROM #set1 s1 LEFT OUTER JOIN #set2 s2 
  ON (s1.col1=s2.col1 AND s1.col2=s2.col2)
WHERE s2.col1 IS NULL
GO
DROP TABLE #set1, #set2

