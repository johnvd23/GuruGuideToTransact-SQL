DROP PROC fixduedates3
GO
CREATE PROCEDURE fixduedates3 AS
SET NOCOUNT ON
UPDATE DUEDATES SET DueDate=DueDate+
	CASE WHEN DATEPART(dw,DueDate)=6 THEN 3 
	WHEN (DATEPART(dw,DueDate)=5) AND EXISTS (SELECT HolidayDate FROM HOLIDAYS WHERE HolidayDate=DueDate+1) THEN 4
	ELSE 1 
	END
FROM HOLIDAYS WHERE DueDate = HolidayDate
GO
EXEC fixduedates3