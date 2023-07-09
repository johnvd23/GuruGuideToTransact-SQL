DROP PROC listsales_cur
GO
CREATE PROC listsales_cur @title_id tid, @salescursor cursor varying OUT
AS
-- Declare a LOCAL cursor so it's automatically freed when it 
-- goes out of scope
DECLARE c CURSOR DYNAMIC
LOCAL	
FOR SELECT * FROM sales WHERE title_id LIKE @title_id

DECLARE @sc cursor  	-- A local cursor variable
SET @sc=c		-- Now we have two references to the cursor

OPEN c

FETCH @sc

SET @salescursor=@sc	-- Return the cursor via the output parm
RETURN 0
GO

SET NOCOUNT ON
-- Define a local cursor variable to receive the output parm
DECLARE @mycursor cursor 

EXEC listsales_cur 'BU1032', @mycursor OUT -- Call the procedure

-- Make sure the returned cursor is open and has at least one row
IF (CURSOR_STATUS('variable','@mycursor')=1) BEGIN
  FETCH @mycursor
  WHILE (@@FETCH_STATUS=0) BEGIN
    FETCH @mycursor
  END
END

CLOSE @mycursor
DEALLOCATE @mycursor

