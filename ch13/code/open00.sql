SET NOCOUNT ON
CREATE TABLE #temp (k1 int identity PRIMARY KEY, c1 int NULL)

INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES

DECLARE GlobalCursor CURSOR STATIC  -- Declare a GLOBAL cursor
GLOBAL
FOR SELECT k1, c1 FROM #temp

DECLARE LocalCursor CURSOR STATIC -- Declare a LOCAL cursor 
LOCAL
FOR SELECT k1, c1 FROM #temp WHERE k1<4  -- Only returns three rows

OPEN GLOBAL GlobalCursor
SELECT @@CURSOR_ROWS AS NumberOfGLOBALCursorRows 

OPEN LocalCursor
SELECT @@CURSOR_ROWS AS NumberOfLOCALCursorRows 

CLOSE GLOBAL GlobalCursor
DEALLOCATE GLOBAL GlobalCursor
CLOSE LocalCursor
DEALLOCATE LocalCursor
GO
DROP TABLE #temp
