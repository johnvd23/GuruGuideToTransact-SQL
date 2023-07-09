SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SELECT 'Before BEGIN TRAN main',@@TRANCOUNT
BEGIN TRAN main
  SELECT 'After BEGIN TRAN main',@@TRANCOUNT
  DELETE sales
  SAVE TRAN sales	-- Mark a save point
  SELECT 'After SAVE TRAN sales',@@TRANCOUNT -- @@TRANCOUNT is unchanged
  BEGIN TRAN nested
    SELECT 'After BEGIN TRAN nested',@@TRANCOUNT
    DELETE titleauthor
    SAVE TRAN titleauthor -- Mark a save point
    SELECT 'After SAVE TRAN titleauthor',@@TRANCOUNT -- @@TRANCOUNT is unchanged
  ROLLBACK TRAN sales
  SELECT 'After ROLLBACK TRAN sales',@@TRANCOUNT -- @@TRANCOUNT is unchanged
  SELECT TOP 5 au_id FROM titleauthor
IF @@TRANCOUNT>0 BEGIN
  ROLLBACK TRAN	
  SELECT 'After ROLLBACK TRAN',@@TRANCOUNT
END

SELECT TOP 5 au_id FROM titleauthor
