CREATE TABLE #testnotes (k1 int identity, notes text DEFAULT ' ')

BEGIN TRAN
INSERT #testnotes DEFAULT VALUES

DECLARE @textptr binary(16)

SELECT @textptr=TEXTPTR(notes)
FROM #testnotes (UPDLOCK)

WRITETEXT #testnotes.notes @textptr 'ZZZ '

SELECT * FROM #testnotes

COMMIT TRAN

GO
DROP TABLE #testnotes
