DECLARE @outname sysname
SET @outname=''  -- Can't be NULL
EXEC sp_MSuniqueobjectname 'titles',@outname OUT
SELECT @outname