SET NOCOUNT ON
CREATE TABLE #testts (c1 int identity, c2 int DEFAULT 0, changelog timestamp)

INSERT #testts DEFAULT VALUES
INSERT #testts DEFAULT VALUES
INSERT #testts DEFAULT VALUES
INSERT #testts DEFAULT VALUES
INSERT #testts DEFAULT VALUES

SELECT * FROM #testts

UPDATE #testts SET c2=c1

SELECT * FROM #testts

GO
DROP TABLE #testts