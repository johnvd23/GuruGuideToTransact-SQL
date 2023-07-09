CREATE TABLE #test (c1 money)

-- Don’t do this – bad SQL
INSERT #test VALUES('1232')

SELECT * 
FROM #test
GO
DROP TABLE #test
