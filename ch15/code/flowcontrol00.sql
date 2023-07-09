USE pubs
IF OBJECT_ID('dbo.listsales') IS NOT NULL
  DROP PROC dbo.listsales
GO
CREATE PROC dbo.listsales @title_id tid=NULL
AS

IF (@title_id='/?') GOTO Help  	-- Here's a basic IF

-- Here's one with a BEGIN..END block
IF NOT EXISTS(SELECT * FROM titles WHERE title_id=@title_id) BEGIN  
  PRINT 'Invalid title_id'
  WAITFOR DELAY '00:00:03' -- Delay 3 secs to view message
  RETURN -1
END

IF NOT EXISTS(SELECT * FROM sales WHERE title_id=@title_id) BEGIN
  PRINT 'No sales for this title'
  WAITFOR DELAY '00:00:03' -- Delay 3 secs to view message
  RETURN -2
END

DECLARE @qty int, @totalsales int
SET @totalsales=0

DECLARE c CURSOR
FOR SELECT qty FROM sales WHERE title_id=@title_id

OPEN c

FETCH c INTO @qty

WHILE (@@FETCH_STATUS=0) BEGIN	-- Here's a WHILE loop
  IF (@qty<0) BEGIN
    Print 'Bad quantity encountered'
    BREAK	-- Exit the loop immediately
  END ELSE IF (@qty IS NULL) BEGIN
    Print 'NULL quantity encountered -- skipping'      
    FETCH c INTO @qty
    CONTINUE	-- Continue with the next iteration of the loop
  END
  SET @totalsales=@totalsales+@qty
  FETCH c INTO @qty
END

CLOSE c
DEALLOCATE c

SELECT @title_id AS 'TitleID', @totalsales AS 'TotalSales'
RETURN 0	-- Return from the procedure indicating success

Help:
EXEC sp_usage @objectname='listsales',
	@desc='Lists the total sales for a title',
   	@parameters='@title_id="ID of the title you want to check"',
	@example='EXEC listsales "PS2091"',
	@author='Ken Henderson',
	@email='khen@khen.com',
	@version='1', @revision='0',
	@datecreated='19990803', @datelastchanged='19990818'
WAITFOR DELAY '00:00:03' -- Delay 3 secs to view message
RETURN -1
GO

EXEC listsales 'PS2091'
EXEC listsales 'badone'
EXEC listsales 'PC9999'


