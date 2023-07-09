USE pubs
BEGIN TRAN

-- Demonstrate Halloween Problem -- SQL Server is immune to it
UPDATE sales 
SET qty=qty*1.5

GO
ROLLBACK TRAN



