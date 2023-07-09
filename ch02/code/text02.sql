CREATE TABLE #testnotes (k1 int identity, notes text)

INSERT #testnotes (notes) VALUES (REPLICATE('X',8000))

DECLARE @textptr varbinary(16)

SELECT @textptr=TEXTPTR(notes) 
FROM #testnotes

DECLARE @bigtext varchar(8000)
SET @bigtext=REPLICATE('X',8000)

UPDATETEXT #testnotes.notes @textptr 0 0 @bigtext

SELECT DATALENGTH(notes), *
FROM #testnotes 
WHERE notes LIKE '%XX%'

go
DROP TABLE #testnotes
