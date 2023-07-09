DECLARE @cursor1 CURSOR, @cursor2 CURSOR
DECLARE c CURSOR FOR SELECT * FROM authors

SET @cursor1=c
SET @cursor2=@cursor1

OPEN @cursor2
FETCH @cursor2

WHILE (@@FETCH_STATUS=0) BEGIN
  FETCH @cursor1
END

CLOSE @cursor1
DEALLOCATE @cursor1
DEALLOCATE @cursor2
DEALLOCATE c

