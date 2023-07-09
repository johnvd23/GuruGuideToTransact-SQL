SET NOCOUNT ON
USE GG_TS
IF (OBJECT_ID('testmedian') IS NOT NULL)
  DROP TABLE testmedian
GO
CREATE TABLE testmedian 
(k1 int identity, 
 c1 float DEFAULT (
(CASE (CAST(RAND()+.5 AS int)*-1) WHEN 0 THEN 1 ELSE -1 END)*(CAST(RAND() * 100000 AS int) % 10000)*RAND()
),
 c2 int DEFAULT 0
)
INSERT testmedian DEFAULT VALUES
INSERT testmedian DEFAULT VALUES
INSERT testmedian DEFAULT VALUES
INSERT testmedian DEFAULT VALUES
INSERT testmedian DEFAULT VALUES
INSERT testmedian DEFAULT VALUES
INSERT testmedian DEFAULT VALUES
INSERT testmedian DEFAULT VALUES
INSERT testmedian DEFAULT VALUES
INSERT testmedian DEFAULT VALUES

WHILE (SELECT rows FROM sysindexes WHERE id=OBJECT_ID('testmedian') AND indid=0) < 1000000 BEGIN
  INSERT testmedian SELECT TOP 344640 c2 FROM testmedian
  PRINT @@ROWCOUNT
END

CREATE CLUSTERED INDEX k1 ON testmedian (k1)

SET STATISTICS TIME ON
DECLARE @rows int
SELECT @rows=rows FROM sysindexes WHERE id=OBJECT_ID('testmedian') AND indid=1

SELECT AVG(c1) AS Median FROM testmedian 
WHERE k1 BETWEEN @rows / 2 AND (@rows / 2)+1
SET STATISTICS TIME OFF



