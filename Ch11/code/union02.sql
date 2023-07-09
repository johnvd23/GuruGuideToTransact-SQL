SET NOCOUNT ON
CREATE TABLE tempdb..set1 (col1 int, col2 int)
CREATE TABLE tempdb..set2 (col3 int, col4 int)

INSERT tempdb..set1 VALUES (1,1)
INSERT tempdb..set1 VALUES (2,2)
INSERT tempdb..set1 VALUES (3,3)
INSERT tempdb..set1 VALUES (4,4)
INSERT tempdb..set1 VALUES (5,5)

INSERT tempdb..set2 VALUES (1,1)
INSERT tempdb..set2 VALUES (2,2)
INSERT tempdb..set2 VALUES (5,5)
GO
CREATE VIEW tempview AS
SELECT * FROM tempdb..set1
UNION ALL
SELECT * FROM tempdb..set2
GO
SELECT col1, Num=COUNT(*) FROM tempview
GROUP BY col1
HAVING (COUNT(*) > 1)


GO
DROP TABLE tempdb..set1, tempdb..set2
DROP VIEW tempview

