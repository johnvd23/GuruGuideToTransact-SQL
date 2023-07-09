USE pubs
GO
IF OBJECT_ID('author_crosstab2') IS NOT NULL
  DROP PROC author_crosstab2
GO
CREATE PROCEDURE author_crosstab2 
AS 
SET NOCOUNT ON
DECLARE @execsql nvarchar(4000), @AuthorName varchar(80)

CREATE TABLE #autxtab (Title varchar(80))

DECLARE AlterScript CURSOR FOR
SELECT 'ALTER TABLE #autxtab ADD ['+au_fname+' '+au_lname+'] char(1) NULL DEFAULT ""'
FROM authors
FOR READ ONLY

OPEN AlterScript
FETCH AlterScript INTO @execsql
WHILE (@@FETCH_STATUS=0) BEGIN
  EXEC sp_executesql @execsql
  FETCH AlterScript INTO @execsql
END
CLOSE AlterScript
DEALLOCATE AlterScript

DECLARE InsertScript CURSOR FOR 
SELECT execsql='INSERT #autxtab (Title,'+'['+a.au_fname+' '+a.au_lname+']) VALUES ("'+t.title+'", "X")'
FROM titles t JOIN titleauthor ta ON (t.title_id=ta.title_id)
JOIN authors a ON (ta.au_id=a.au_id)
ORDER BY t.title

OPEN InsertScript
FETCH InsertScript INTO @execsql
WHILE (@@FETCH_STATUS=0) BEGIN
  EXEC sp_executesql @execsql
  FETCH InsertScript INTO @execsql
END
CLOSE InsertScript
DEALLOCATE InsertScript

SELECT * FROM #autxtab
DROP TABLE #autxtab

GO

EXEC author_crosstab2
GO
