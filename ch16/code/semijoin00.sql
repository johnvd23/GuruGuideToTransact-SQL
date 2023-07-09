SET NOCOUNT ON

CREATE TABLE #dim1 (dim1 int identity PRIMARY KEY, dim1val int)
CREATE TABLE #dim2 (dim2 int identity PRIMARY KEY, dim2val int)
CREATE TABLE #facttable (k1 int identity PRIMARY KEY, dim1 int, dim2 int)

DECLARE @loop INT
SET @loop=1

WHILE @loop<=10 BEGIN
  INSERT #dim1 VALUES (@loop*50)
  INSERT #dim2 VALUES (@loop*25)
  SET @loop=@loop+1
END

SET @loop=1

WHILE @loop<=1000000 BEGIN
  INSERT #facttable VALUES ((@loop / 100000)+1,10-(@loop / 100000))
  SET @loop=@loop+1
END

CREATE INDEX dim1 ON #facttable (dim1)
CREATE INDEX dim2 ON #facttable (dim2)

SELECT TOP 50 d.dim1val, i.dim2val
FROM #facttable f JOIN #dim1 d ON (f.dim1=d.dim1)
JOIN #dim2 i ON (f.dim2=i.dim2)
WHERE d.dim1val BETWEEN 300 AND 450
AND (f.k1 % 100000) = 0
AND (i.dim2val BETWEEN 100 AND 200)

GO
DROP TABLE #facttable, #dim1, #dim2


