-- DON'T DO THIS -- BAD T-SQL
USE pubs
GO
IF (OBJECT_ID('inputcursorparm') IS NOT NULL)
  DROP PROC inputcursorparm
GO
CREATE PROC inputcursorparm @cursor_input cursor VARYING OUT 
AS
FETCH @cursor_input

WHILE (@@FETCH_STATUS=0) BEGIN
  FETCH @cursor_input
END

CLOSE @cursor_input
DEALLOCATE @cursor_input
GO

DECLARE @c CURSOR 
SET @c=CURSOR FOR SELECT * FROM authors 

-- An error is generated when the procedure is called 
-- because @c references an existing cursor
EXEC inputcursorparm @c OUT
