USE tempdb
GO
DROP TABLE DUEDATES
GO
CREATE TABLE DUEDATES (CheckOutDate smalldatetime, DueDate smalldatetime)
GO
DROP PROC popduedates
GO
CREATE PROCEDURE popduedates AS
  SET NOCOUNT ON
  DECLARE @year integer, @insertday datetime

  SELECT @year=YEAR(GETDATE()), @insertday=CAST(@year AS char(4))+'0101'
  TRUNCATE TABLE DUEDATES -- In case the routine is run more than once (run only from tempdb)
  WHILE YEAR(@insertday)=@year BEGIN
    -- Don't insert weekend or holiday CheckOut dates -- library is closed
    IF ((SELECT DATEPART(dw,@insertday)) NOT IN (1,7))
    AND NOT EXISTS (SELECT * FROM HOLIDAYS WHERE HolidayDate=@insertday)
      INSERT DUEDATES VALUES (@insertday, @insertday+14)
    SET @insertday=@insertday+1
  END
GO
EXEC popduedates