SET NOCOUNT ON
USE pubs

SET CURSOR_CLOSE_ON_COMMIT ON  
BEGIN TRAN

DECLARE c CURSOR DYNAMIC
FOR SELECT qty FROM sales

OPEN c  

FETCH c

UPDATE sales
SET qty=qty+1
WHERE CURRENT OF c

ROLLBACK TRAN

-- These FETCHes will fail because the cursor was closed by the ROLLBACK
FETCH c 
FETCH LAST FROM c 

-- This CLOSE will fail because the cursor was closed by the ROLLBACK
CLOSE c 
DEALLOCATE c
GO
SET CURSOR_CLOSE_ON_COMMIT OFF
