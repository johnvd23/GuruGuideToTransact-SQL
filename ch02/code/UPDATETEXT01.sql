CREATE TABLE #testnotes (k1 int identity, notes text DEFAULT ' ')

BEGIN TRAN
INSERT #testnotes DEFAULT VALUES

UPDATE #testnotes SET notes='Women and Babies First'

DECLARE @textptr binary(16), @patindex int, @patlength int

SELECT @textptr=TEXTPTR(notes), @patindex=PATINDEX('%Babies%',notes)-1,
@patlength=DATALENGTH('Babies')
FROM #testnotes (UPDLOCK)
WHERE PATINDEX('%Babies%',notes)<>0

UPDATETEXT #testnotes.notes @textptr @patindex @patlength 'Children'

SELECT * FROM #testnotes

COMMIT TRAN

GO
DROP TABLE #testnotes
