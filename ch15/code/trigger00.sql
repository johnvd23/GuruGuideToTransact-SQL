SET NOCOUNT ON
USE pubs
DROP TRIGGER SalesQty_INSERT_UPDATE
GO
CREATE TRIGGER SalesQty_INSERT_UPDATE ON sales FOR INSERT, UPDATE AS

IF @@ROWCOUNT=0 RETURN -- No rows affected, exit immediately

IF (UPDATE(qty)) AND (SELECT MIN(qty) FROM inserted)<10 BEGIN
  RAISERROR('Minimum order is 10 units',16,10)
  ROLLBACK TRAN
  RETURN
END
GO

-- Test a single-row INSERT
BEGIN TRAN
  INSERT sales VALUES (6380,'ORD9997',GETDATE(),5,'Net 60','BU1032')
IF @@TRANCOUNT>0 ROLLBACK TRAN
GO

-- Test a multi-row INSERT
BEGIN TRAN
  INSERT sales 
  SELECT stor_id, ord_num+'A', ord_date, 5, payterms, title_id FROM sales
IF @@TRANCOUNT>0 ROLLBACK TRAN
GO

DROP TRIGGER Sales_DELETE
GO
CREATE TRIGGER Sales_DELETE ON sales FOR DELETE AS

IF @@ROWCOUNT=0 RETURN -- No rows affected, exit immediately

IF (@@ROWCOUNT>1) BEGIN
  RAISERROR('Deletions of more than one row at a time are not permitted',16,10)
  ROLLBACK TRAN
  RETURN
END
GO
BEGIN TRAN
  DELETE sales
IF @@TRANCOUNT>0 ROLLBACK TRAN
GO

DROP TRIGGER Salesord_date_qty_UPDATE
GO
CREATE TRIGGER Salesord_date_qty_UPDATE ON sales FOR INSERT, UPDATE AS

IF @@ROWCOUNT=0 RETURN -- No rows affected, exit immediately

-- Check to see whether the 3rd and 4th columns are being updated simultaneously
IF (COLUMNS_UPDATED() & (POWER(2,3-1) | POWER(2,4-1)))=12 BEGIN

  UPDATE s SET payterms='Cash'
  FROM sales s JOIN inserted i ON (s.stor_id=i.stor_id AND s.ord_num=i.ord_num)

  IF (@@ERROR<>0) -- UPDATE generated an error, rollback transaction
    ROLLBACK TRANSACTION
  RETURN

END
GO

-- Test with a single-row UPDATE
BEGIN TRAN
  UPDATE sales SET ord_date=GETDATE(), qty=15
  WHERE stor_id=7066 and ord_num='A2976'

  SELECT * FROM sales
  WHERE stor_id=7066 and ord_num='A2976'
IF @@TRANCOUNT>0 ROLLBACK TRAN
GO

-- Test with a multi-row UPDATE
BEGIN TRAN
  UPDATE sales SET ord_date=GETDATE(), qty=15
  WHERE stor_id=7066 

  SELECT * FROM sales
  WHERE stor_id=7066 
IF @@TRANCOUNT>0 ROLLBACK TRAN

