SET NOCOUNT ON
CREATE TABLE #testblob (c1 text DEFAULT ' ')

INSERT #testblob VALUES ('Golf is a good walk spoiled')
INSERT #testblob VALUES ('Now is the time for all good men')
INSERT #testblob VALUES ('Good Golly! Miss Molly')

SELECT * 
FROM #testblob 
WHERE c1 LIKE '%good%'

SELECT * 
FROM #testblob 
WHERE PATINDEX('%good%',c1)>15
GO
DROP TABLE #testblob
