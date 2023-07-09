CREATE TABLE #test (c1 money)

INSERT #test SELECT CAST('1232' AS money)

SELECT * 
FROM #test
GO
DROP TABLE #test
