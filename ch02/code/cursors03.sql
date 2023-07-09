DECLARE @cursor CURSOR
DECLARE c CURSOR GLOBAL FOR SELECT * FROM authors

OPEN c

EXEC sp_describe_cursor @cursor_return=@cursor OUTPUT, 
@cursor_source=N'global', 
@cursor_identity=N'c'

FETCH @cursor

FETCH c
WHILE (@@FETCH_STATUS=0) BEGIN
  FETCH c
END

CLOSE @cursor
CLOSE c
DEALLOCATE @cursor
DEALLOCATE c
