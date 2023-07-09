SET NOCOUNT ON
CREATE TABLE #testuid (k1 uniqueidentifier DEFAULT NEWID(), k2 int identity)

INSERT #testuid DEFAULT VALUES
INSERT #testuid DEFAULT VALUES
INSERT #testuid DEFAULT VALUES
INSERT #testuid DEFAULT VALUES

SELECT * FROM #testuid
GO
DROP TABLE #testuid