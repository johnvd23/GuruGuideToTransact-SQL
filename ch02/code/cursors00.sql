DECLARE @cursor CURSOR

SET @cursor=CURSOR FOR SELECT * FROM authors

OPEN @cursor
FETCH @cursor

WHILE (@@FETCH_STATUS=0) BEGIN
  FETCH @cursor
END

CLOSE @cursor
DEALLOCATE @cursor