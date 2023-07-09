USE pubs
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('TABLE') IS NOT NULL
  DROP PROC "TABLE"
GO
CREATE PROC "TABLE" @tableclause varchar(8000),
@columnclause varchar(8000)='*', 
@whereclause varchar(8000)=NULL,
@groupbyclause varchar(8000)=NULL,
@havingclause varchar(8000)=NULL,
@orderbyclause varchar(8000)=NULL,
@computeclause varchar(8000)=NULL
AS
DECLARE @execstr varchar(8000)
SET @execstr='SELECT '+@columnclause+' FROM '+@tableclause
+ISNULL(' WHERE '+@whereclause,' ')
+ISNULL(' GROUP BY '+@groupbyclause,' ')
+ISNULL(' HAVING '+@havingclause,' ')
+ISNULL(' ORDER BY '+@orderbyclause,' ')
+ISNULL(' COMPUTE '+@computeclause,'')

EXEC(@execstr)
GO
SET QUOTED_IDENTIFIER OFF
GO
