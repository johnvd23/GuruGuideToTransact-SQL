-- Query 2
BEGIN TRAN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
-- This INSERT will be delayed until the first transaction completes
INSERT sales VALUES (6380,9999999,GETDATE(),2,'USG-Whenever','PS2091')
ROLLBACK TRAN