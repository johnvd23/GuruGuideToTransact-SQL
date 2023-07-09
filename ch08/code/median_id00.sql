SET NOCOUNT ON
USE GG_TS
IF (OBJECT_ID('financial_median') IS NOT NULL)
  DROP TABLE financial_median
GO
DECLARE @starttime datetime

SET @starttime=GETDATE()

CREATE TABLE financial_median 
(
c1 float DEFAULT (
 (CASE (CAST(RAND()+.5 AS int)*-1) WHEN 0 THEN 1 ELSE -1 END)*(CAST(RAND() * 100000 AS int) % 10000)*RAND()),
c2 int DEFAULT 0
)

-- Seed the table with 10 rows
INSERT financial_median DEFAULT VALUES
INSERT financial_median DEFAULT VALUES
INSERT financial_median DEFAULT VALUES
INSERT financial_median DEFAULT VALUES
INSERT financial_median DEFAULT VALUES
INSERT financial_median DEFAULT VALUES
INSERT financial_median DEFAULT VALUES
INSERT financial_median DEFAULT VALUES
INSERT financial_median DEFAULT VALUES
INSERT financial_median DEFAULT VALUES

-- Create a distribution of a million values
WHILE (SELECT TOP 1 rows FROM sysindexes WHERE id=OBJECT_ID('financial_median') ORDER BY indid) < 1000000 BEGIN
  INSERT financial_median (c2) SELECT TOP 344640 c2 FROM financial_median
END

SELECT 'It took '+CAST(DATEDIFF(ss,@starttime,GETDATE()) AS varchar)+' seconds to create and populate the table'

SET @starttime=GETDATE()
-- Sort the distribution
CREATE CLUSTERED INDEX c1 ON financial_median (c1)
ALTER TABLE financial_median ADD k1 int identity 
DROP INDEX financial_median.c1
CREATE CLUSTERED INDEX k1 ON financial_median (k1) 

SELECT 'It took '+CAST(DATEDIFF(ss,@starttime,GETDATE()) AS varchar)+' seconds to sort the table'
GO

-- Compute the financial median
DECLARE @starttime datetime, @rows int
SET @starttime=GETDATE()
SET STATISTICS TIME ON
SELECT TOP 1 @rows=rows FROM sysindexes WHERE id=OBJECT_ID('financial_median') ORDER BY indid

SELECT 'There are '+CAST(@rows AS varchar)+' rows'

SELECT AVG(c1) AS "The financial median is" FROM financial_median 
WHERE k1 BETWEEN @rows / 2 AND (@rows / 2)+SIGN(@rows+1 % 2)
SET STATISTICS TIME OFF
SELECT 'It took '+CAST(DATEDIFF(ms,@starttime,GETDATE()) AS varchar)+' ms to compute the financial median'


