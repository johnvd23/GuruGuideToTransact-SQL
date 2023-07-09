SET NOCOUNT ON
DECLARE @statusid int

CREATE TABLE ##jobstatus 
(statusid int identity,
 start datetime, 
 finish datetime NULL,
 descripton varchar(50),
 complete bit DEFAULT 0)

INSERT ##jobstatus VALUES (GETDATE(),NULL,'Updating index stats for pubs',0)
SET @statusid=@@IDENTITY
PRINT ''
SELECT descripton AS 'JOB CURRENTLY EXECUTING' FROM ##jobstatus WHERE statusid=@statusid
EXEC pubs..sp_updatestats
UPDATE ##jobstatus SET finish=GETDATE(), complete=1 
WHERE statusid=@statusid

INSERT ##jobstatus VALUES (GETDATE(),NULL,'Updating index stats for northwind',0)
SET @statusid=@@IDENTITY
PRINT ''
SELECT descripton AS 'JOB CURRENTLY EXECUTING' FROM ##jobstatus WHERE statusid=@statusid
EXEC northwind..sp_updatestats
UPDATE ##jobstatus SET finish=GETDATE(), complete=1 
WHERE statusid=@statusid

SELECT * FROM ##jobstatus
GO
DROP TABLE ##jobstatus
