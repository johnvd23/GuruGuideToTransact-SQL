SET NOCOUNT ON
SELECT AuthorId=IDENTITY(int), au_lname, au_fname INTO #testident FROM authors

USE tempdb
SELECT COLUMNPROPERTY(OBJECT_ID('#testident'),'AuthorId','IsIdentity')
USE pubs
GO
DROP TABLE #testident
