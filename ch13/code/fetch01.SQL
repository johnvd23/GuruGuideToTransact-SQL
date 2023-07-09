DECLARE C CURSOR 
FOR SELECT title_id, qty FROM sales

DECLARE @TitleId tid, @Quantity smallint

OPEN c
FETCH c INTO @TitleId, @Quantity
WHILE (@@FETCH_STATUS=0) BEGIN
  SELECT @TitleId, @Quantity
  FETCH c INTO @TitleId, @Quantity
END

CLOSE c
DEALLOCATE c
