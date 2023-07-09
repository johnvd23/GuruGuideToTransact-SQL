-- Query 1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
PRINT 'Now you see it...'
SELECT TOP 5 title_id, qty FROM sales ORDER BY title_id, stor_id 
WAITFOR DELAY '00:00:05'
PRINT '...now you don''t'
SELECT TOP 5 title_id, qty FROM sales ORDER BY title_id, stor_id 
GO
ROLLBACK TRAN
