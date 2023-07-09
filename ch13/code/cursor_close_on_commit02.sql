SET NOCOUNT ON
USE pubs

SET CURSOR_CLOSE_ON_COMMIT OFF
BEGIN TRAN

DECLARE c CURSOR DYNAMIC
FOR SELECT qty FROM sales

OPEN c  

FETCH c

UPDATE sales
SET qty=qty+1
WHERE CURRENT OF c

ROLLBACK TRAN

-- These FETCHes will succeed because the cursor was left open in spite of the 
-- ROLLBACK
FETCH c 
FETCH LAST FROM c 

-- This CLOSE will succeed because the cursor was left open in spite of the 
-- ROLLBACK
CLOSE c 
DEALLOCATE c
GO
