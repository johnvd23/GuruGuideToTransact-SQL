SET NOCOUNT ON
CREATE TABLE #testident (k1 int identity, c1 int DEFAULT 0)

INSERT #testident DEFAULT VALUES
INSERT #testident DEFAULT VALUES
INSERT #testident DEFAULT VALUES

SELECT IDENTITYCOL FROM #testident
GO
DROP TABLE #testident
