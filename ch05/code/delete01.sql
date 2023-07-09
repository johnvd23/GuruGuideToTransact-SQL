SET NOCOUNT ON
USE pubs
GO
BEGIN TRAN

SELECT TOP 10 ord_num AS Before FROM sales ORDER BY ord_num

DELETE s
FROM sales s JOIN (SELECT TOP 5 ord_num FROM sales ORDER BY ord_num) a 
ON (s.ord_num=a.ord_num)

SELECT TOP 10 ord_num AS After FROM sales ORDER BY ord_num

GO
ROLLBACK TRAN