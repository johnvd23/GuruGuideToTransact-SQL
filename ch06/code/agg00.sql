SET NOCOUNT ON
CREATE TABLE #testnull (c1 int null)

INSERT #testnull DEFAULT VALUES
INSERT #testnull DEFAULT VALUES


SELECT COUNT(*), COUNT(c1) FROM #testnull
GO
DROP TABLE #testnull
