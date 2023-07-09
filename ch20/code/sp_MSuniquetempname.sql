CREATE TABLE tempdb..test (c1 int)
DECLARE @outname sysname
--SET @outname=''  -- Can't be NULL
EXEC sp_MSuniquetempname 'test',@outname OUT
SELECT @outname
GO
DROP TABLE tempdb..test