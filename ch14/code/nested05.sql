SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SELECT 'Before BEGIN TRAN',@@TRANCOUNT
BEGIN TRAN
  SELECT 'After BEGIN TRAN',@@TRANCOUNT
  DELETE sales
  BEGIN TRAN nested
    SELECT 'After BEGIN TRAN nested',@@TRANCOUNT
    DELETE titleauthor
  IF @@ROWCOUNT > 1000
     COMMIT TRAN nested
  ELSE BEGIN
    ROLLBACK TRAN -- Completely rolls back both transactions
    SELECT 'After ROLLBACK TRAN',@@TRANCOUNT 
  END
  SELECT TOP 5 au_id FROM titleauthor
ROLLBACK TRAN -- This is an error - there's no transaction to rollback
SELECT 'After ROLLBACK TRAN',@@TRANCOUNT

SELECT TOP 5 au_id FROM titleauthor
