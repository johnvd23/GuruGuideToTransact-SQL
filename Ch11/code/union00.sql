SET NOCOUNT ON
CREATE TABLE #set1 (col1 int, col2 int)
CREATE TABLE #set2 (col3 int, col4 int)

INSERT #set1 VALUES (1,1)
INSERT #set1 VALUES (2,2)
INSERT #set1 VALUES (3,3)
INSERT #set1 VALUES (4,4)
INSERT #set1 VALUES (5,5)

INSERT #set2 VALUES (1,1)
INSERT #set2 VALUES (2,2)
INSERT #set2 VALUES (5,5)

SELECT * FROM #set1
UNION
SELECT * FROM #set2

GO
DROP TABLE #set1, #set2

