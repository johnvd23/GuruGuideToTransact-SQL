SET NOCOUNT ON
CREATE TABLE #valueset (c1 int)
INSERT #valueset VALUES (2)
INSERT #valueset VALUES (2)  -- Duplicate value
INSERT #valueset VALUES (1)
INSERT #valueset VALUES (3)
INSERT #valueset VALUES (4)
INSERT #valueset VALUES (4)  -- Duplicate value
INSERT #valueset VALUES (11)  -- Duplicate value
INSERT #valueset VALUES (11)
INSERT #valueset VALUES (13)

SET ROWCOUNT 3
SELECT * FROM #valueset ORDER BY c1
SET ROWCOUNT 0 -- Reset to normal
GO
DROP TABLE #valueset
