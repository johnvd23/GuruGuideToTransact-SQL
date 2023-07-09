DECLARE @cursor CURSOR
DECLARE c CURSOR FOR SELECT * FROM authors

SET @cursor=c

DEALLOCATE c

OPEN @cursor
FETCH @cursor

WHILE (@@FETCH_STATUS=0) BEGIN
  FETCH @cursor
END

CLOSE @cursor
DEALLOCATE @cursor
