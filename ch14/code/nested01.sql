SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SELECT 'Before BEGIN TRAN',@@TRANCOUNT
BEGIN TRAN
  SELECT 'After BEGIN TRAN',@@TRANCOUNT
  DELETE sales
  BEGIN TRAN nested
    SELECT 'After BEGIN TRAN nested',@@TRANCOUNT
    DELETE titleauthor
  ROLLBACK TRAN 
  SELECT 'After ROLLBACK TRAN',@@TRANCOUNT
IF @@TRANCOUNT>0 BEGIN
  COMMIT TRAN	-- Never makes it here because of the ROLLBACK
  SELECT 'After COMMIT TRAN',@@TRANCOUNT
END

SELECT TOP 5 au_id FROM titleauthor
