SET NOCOUNT ON
CREATE TABLE #valueset (c1 int)
INSERT #valueset VALUES (2)
INSERT #valueset VALUES (2)  -- Duplicate value
INSERT #valueset VALUES (1)
INSERT #valueset VALUES (3)
INSERT #valueset VALUES (4)
INSERT #valueset VALUES (4)  -- Duplicate value
INSERT #valueset VALUES (11) 
INSERT #valueset VALUES (11) -- Duplicate value
INSERT #valueset VALUES (13)

DECLARE @endc1 int

SELECT DISTINCT TOP 3 @endc1=c1 FROM #valueset ORDER BY c1 -- Get third distinct value

SELECT * FROM #valueset WHERE c1 <= @endc1 ORDER BY c1 
GO
DROP TABLE #valueset
