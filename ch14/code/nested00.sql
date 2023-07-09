SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SELECT 'Before BEGIN TRAN',@@TRANCOUNT
BEGIN TRAN
  SELECT 'After BEGIN TRAN',@@TRANCOUNT
  DELETE sales
  BEGIN TRAN nested
    SELECT 'After BEGIN TRAN nested',@@TRANCOUNT
    DELETE titleauthor
  COMMIT TRAN nested -- Does nothing except decrement @@TRANCOUNT
  SELECT 'After COMMIT TRAN nested',@@TRANCOUNT
GO	-- When possible, it's a good idea to place ROLLBACK TRAN in a separate batch 
	-- to prevent batch errors from leaving open transactions
ROLLBACK TRAN
SELECT 'After ROLLBACK TRAN',@@TRANCOUNT

SELECT TOP 5 au_id FROM titleauthor
