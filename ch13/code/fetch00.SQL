SET NOCOUNT ON
CREATE TABLE #cursortest (k1 int identity)

INSERT #cursortest DEFAULT VALUES
INSERT #cursortest DEFAULT VALUES
INSERT #cursortest DEFAULT VALUES
INSERT #cursortest DEFAULT VALUES
INSERT #cursortest DEFAULT VALUES
INSERT #cursortest DEFAULT VALUES
INSERT #cursortest DEFAULT VALUES
INSERT #cursortest DEFAULT VALUES
INSERT #cursortest DEFAULT VALUES
INSERT #cursortest DEFAULT VALUES

DECLARE c CURSOR SCROLL
FOR SELECT * FROM #cursortest

OPEN c

FETCH c -- Gets the first row
FETCH ABSOLUTE 4 FROM c -- Gets the 4th row
FETCH RELATIVE -1 FROM c -- Gets the 3rd row
FETCH LAST FROM c -- Gets the last row
FETCH FIRST FROM c -- Gets the first row

CLOSE c
DEALLOCATE c
GO
DROP TABLE #cursortest