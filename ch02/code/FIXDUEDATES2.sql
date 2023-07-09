DROP PROC fixduedates2
GO
CREATE PROCEDURE fixduedates2 AS
SET NOCOUNT ON
SELECT 'Fixing DUEDATES'  -- Seed @@rowcount
WHILE (@@rowcount<>0) BEGIN
  UPDATE DUEDATES SET DueDate=DueDate+CASE WHEN DATEPART(dw,DueDate)=6 THEN 3 ELSE 1 END
  WHERE DueDate IN (SELECT HolidayDate FROM HOLIDAYS)
END
GO
EXEC fixduedates2