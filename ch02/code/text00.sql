CREATE TABLE #testnotes (k1 int identity, notes text)

INSERT #testnotes (notes) VALUES ('test')

GO
-- Don't run this -- doesn't work
SELECT * 
FROM #testnotes 
WHERE notes='test'
GO
DROP TABLE #testnotes
GO
