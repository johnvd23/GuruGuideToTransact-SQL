SET NOCOUNT ON
CREATE TABLE #tmp1 (k1 int identity PRIMARY KEY)
CREATE TABLE #tmp2 (k1 int identity PRIMARY KEY)
CREATE TABLE #tmp3 (k1 int identity PRIMARY KEY)

DECLARE @loop int
SET @loop=1

WHILE @loop<=10 BEGIN
  INSERT #tmp1 DEFAULT VALUES
  INSERT #tmp2 DEFAULT VALUES
  INSERT #tmp3 DEFAULT VALUES
  SET @loop=@loop+1
END

SELECT COUNT(*)
FROM #tmp1 t1, #tmp2 t2, #tmp3 t3
WHERE t1.k1=t2.k1 AND t2.k1=t3.k1

SELECT COUNT(*)
FROM #tmp1 t1 JOIN #tmp2 t2 ON (t1.k1=t2.k1)
JOIN #tmp3 t3 ON (t2.k1=t3.k1)
GO
DROP TABLE #tmp1, #tmp2, #tmp3

