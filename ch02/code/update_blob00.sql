CREATE TABLE #testnotes (k1 int identity, notes text DEFAULT SPACE(10))

INSERT #testnotes DEFAULT VALUES

INSERT #testnotes (notes) VALUES (REPLICATE('X',20))

UPDATE #testnotes SET notes=REPLICATE('Y',10) WHERE k1=1

SELECT * FROM #testnotes

DROP TABLE #testnotes
