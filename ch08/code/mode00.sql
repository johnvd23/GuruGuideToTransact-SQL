SET NOCOUNT ON
CREATE TABLE #valueset (c1 int)
INSERT #valueset VALUES (2)
INSERT #valueset VALUES (2)
INSERT #valueset VALUES (1)
INSERT #valueset VALUES (3)
INSERT #valueset VALUES (4)
INSERT #valueset VALUES (4)
INSERT #valueset VALUES (10)
INSERT #valueset VALUES (11)
INSERT #valueset VALUES (13)

SELECT TOP 1 WITH TIES c1, COUNT(*) AS NumInstances
FROM #valueset
GROUP BY c1
ORDER BY NumInstances DESC
GO
DROP TABLE #valueset
