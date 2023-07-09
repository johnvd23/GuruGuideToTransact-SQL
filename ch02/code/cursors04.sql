SET NOCOUNT ON
DECLARE @authorcursor CURSOR, @authorcursor2 CURSOR, @cursorlist CURSOR
DECLARE AuthorsList CURSOR GLOBAL FOR SELECT * FROM authors

SET @authorcursor=AuthorsList
SET @authorcursor2=AuthorsList

OPEN AuthorsList

EXEC sp_cursor_list @cursor_return=@cursorlist OUTPUT, 
@cursor_scope=3

FETCH @cursorlist
WHILE (@@FETCH_STATUS=0) BEGIN
  FETCH @cursorlist
END

CLOSE @cursorlist
CLOSE AuthorsList

DEALLOCATE @cursorlist
DEALLOCATE AuthorsList
DEALLOCATE @authorcursor
DEALLOCATE @authorcursor2

