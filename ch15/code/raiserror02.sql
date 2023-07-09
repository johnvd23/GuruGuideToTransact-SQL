DECLARE c CURSOR
FOR SELECT title_id, SUM(qty) as sales FROM sales GROUP BY title_id

DECLARE @title_id tid, @qty int

OPEN c

RAISERROR('Starting loop',1,1) -- Seed @@ERROR
WHILE (@@ERROR<=1) BEGIN
  FETCH c INTO @title_id, @qty
  IF (@@FETCH_STATUS=0)
    RAISERROR('Title ID %s has sold %d units',1,1,@title_id,@qty)
  ELSE
    BREAK
END

CLOSE c

DEALLOCATE c
