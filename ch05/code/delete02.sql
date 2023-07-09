SET NOCOUNT ON
USE pubs
BEGIN TRAN

SELECT COUNT(*) AS CountBefore FROM sales 

TRUNCATE TABLE sales

SELECT COUNT(*) AS CountAfter FROM sales 

GO
ROLLBACK TRAN

SELECT COUNT(*) AS CountAfterRollback FROM sales 
