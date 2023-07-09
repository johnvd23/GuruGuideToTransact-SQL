SET NOCOUNT ON
USE pubs
SET CURSOR_CLOSE_ON_COMMIT OFF
DECLARE C CURSOR DYNAMIC
FOR SELECT * FROM sales

OPEN c

FETCH c

BEGIN TRAN -- Start a transaction so that we can reverse our changes

-- A positioned UPDATE
UPDATE sales SET qty=qty+1 WHERE CURRENT OF c 

FETCH RELATIVE 0 FROM c

FETCH c

-- A positioned DELETE
DELETE sales WHERE CURRENT OF c

SELECT * FROM sales WHERE qty=3

ROLLBACK TRAN -- Throw away our changes

SELECT * FROM sales WHERE qty=3 -- The deleted row comes back

CLOSE c
DEALLOCATE c
