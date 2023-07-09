CREATE TABLE #nulltest
(c1 int NULL)
go
INSERT #nulltest VALUES (1)
INSERT #nulltest VALUES (NULL)
INSERT #nulltest VALUES (3)
go

SELECT AVG(c1) FROM #nulltest
SELECT SUM(c1) FROM #nulltest
SELECT MIN(c1) FROM #nulltest
SELECT MAX(c1) FROM #nulltest
SELECT COUNT(*) FROM #nulltest
SELECT COUNT(c1) FROM #nulltest
SELECT SUM(c1)/COUNT(c1) FROM #nulltest

DROP TAble #nulltest
go
