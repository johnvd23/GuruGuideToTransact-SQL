-- Query 2
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
PRINT 'Now you see it...'
SELECT TOP 5 title_id, qty FROM sales 
WHERE qty=0
ORDER BY title_id, stor_id 

IF @@ROWCOUNT>0 BEGIN
  WAITFOR DELAY '00:00:05'

  PRINT '...now you don''t'
  SELECT TOP 5 title_id, qty FROM sales 
  WHERE qty=0
  ORDER BY title_id, stor_id 
END
