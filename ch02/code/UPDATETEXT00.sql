CREATE TABLE #testnotes (k1 int identity, notes text DEFAULT REPLICATE('X',20))

BEGIN TRAN
INSERT #testnotes DEFAULT VALUES

DECLARE @textptr binary(16)

SELECT @textptr=TEXTPTR(notes)
FROM #testnotes (UPDLOCK)

UPDATETEXT #testnotes.notes @textptr 0 0 'ZZZ '

SELECT * FROM #testnotes

COMMIT TRAN

GO
DROP TABLE #testnotes
