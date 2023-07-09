CREATE TABLE #testnotes (k1 int identity, notes text)

INSERT #testnotes (notes) VALUES ('test')

GO

SELECT * 
FROM #testnotes 
WHERE notes LIKE 'test'
GO
DROP TABLE #testnotes
GO
