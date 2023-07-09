SET NOCOUNT ON
USE pubs
CREATE TABLE #temp (k1 int identity PRIMARY KEY, c1 int NULL)

INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES
INSERT #temp DEFAULT VALUES


DECLARE c CURSOR DYNAMIC
FOR SELECT k1, c1 FROM #temp

OPEN c  

SET CURSOR_CLOSE_ON_COMMIT ON
BEGIN TRAN

UPDATE #temp
SET c1=2
WHERE k1=1

COMMIT TRAN

-- These FETCHes will fail because the cursor was closed by the COMMIT
FETCH c 
FETCH LAST FROM c 

-- This CLOSE will fail because the cursor was closed by the COMMIT
CLOSE c 
DEALLOCATE c
GO
DROP TABLE #temp
SET CURSOR_CLOSE_ON_COMMIT OFF
