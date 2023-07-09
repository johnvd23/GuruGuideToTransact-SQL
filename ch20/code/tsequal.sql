USE tempdb
CREATE TABLE #testts 
(k1 int identity,
timestamp timestamp)

DECLARE @ts1 timestamp, @ts2 timestamp

SELECT @ts1=@@DBTS, @ts2=@ts1

SELECT CASE WHEN TSEQUAL(@ts1, @ts2) THEN 'Equal' ELSE 'Not Equal' END

INSERT #testts DEFAULT VALUES

SET @ts2=@@DBTS

SELECT CASE WHEN TSEQUAL(@ts1, @ts2) THEN 'Equal' ELSE 'Not Equal' END
GO
DROP TABLE #testts

