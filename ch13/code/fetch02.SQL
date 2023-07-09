USE pubs
SET CURSOR_CLOSE_ON_COMMIT OFF  -- In case it's been turned on previously
SET NOCOUNT ON

DECLARE c CURSOR SCROLL
FOR SELECT title_id, qty FROM sales ORDER BY qty

OPEN c


BEGIN TRAN  -- So that we can undo the changes we make

PRINT 'Before image'

FETCH c 

UPDATE sales 
SET qty=4 
WHERE qty=3 -- We happen to know that only one row qualifies, the first one

PRINT 'After image'
FETCH RELATIVE 0 FROM c 

ROLLBACK TRAN -- Reverse the UPDATE

CLOSE c
DEALLOCATE c
