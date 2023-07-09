SET NOCOUNT ON
INSERT sales
VALUES ('8042','QA879.1',GETDATE(),30,'Net 30','BU1032')
INSERT sales 
VALUES ('6380','D4482',GETDATE(),11,'Net 60','PS2091')
INSERT sales 
VALUES ('6380','D4492',GETDATE()+1,53,'Net 30','PS2091')
GO
CREATE VIEW DAILY_SALES AS
SELECT *
FROM sales
WHERE ord_date BETWEEN 
               (CASE DATEPART(DW,CONVERT(char(8),GETDATE(),112)) 
	       WHEN 1 THEN CONVERT(char(8),GETDATE()+1,112) 
	       WHEN 7 THEN CONVERT(char(8),GETDATE()-1,112) 
	       ELSE CONVERT(char(8),GETDATE(),112) 
	       END)
 AND           (CASE DATEPART(DW,CONVERT(char(8),GETDATE(),112)) 
	       WHEN 1 THEN CONVERT(char(8),GETDATE()+1,112) 
	       WHEN 7 THEN CONVERT(char(8),GETDATE()-1,112) 
	       ELSE CONVERT(char(8),GETDATE(),112) 
	       END+' 23:59:59.999')
GO
SELECT * FROM DAILY_SALES
GO
DROP VIEW DAILY_SALES