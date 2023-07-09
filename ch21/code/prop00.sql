CREATE TABLE #testfunc (k1 int identity PRIMARY KEY, c1 decimal(10,2), c3 AS k1*c1)

USE tempdb
SELECT COLUMNPROPERTY(OBJECT_ID('#testfunc'),'k1','IsIdentity'),
COLUMNPROPERTY(OBJECT_ID('#testfunc'),'c1','Scale'),
COLUMNPROPERTY(OBJECT_ID('#testfunc'),'c3','IsComputed'),
COLUMNPROPERTY(OBJECT_ID('#testfunc'),'k1','AllowsNull')


GO
DROP TABLE #testfunc