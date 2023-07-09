CREATE PROCEDURE fixduedates AS
DECLARE @keepgoing integer
SET @keepgoing=1
WHILE (@keepgoing<>0) BEGIN
  UPDATE #DUEDATES SET DateDue=DateDue+1
  WHERE DateDue IN (SELECT HolidayDate FROM HOLIDAYS)

  SET @keepgoing=@@rowcount

  UPDATE #DUEDATES SET DateDue=DateDue+2
  WHERE DATEPART(dw,DateDue)=7 

  SET @keepgoing=@keepgoing+@@rowcount

  UPDATE #DUEDATES SET DateDue=DateDue+1
  WHERE DATEPART(dw,DateDue)=1 

  SET @keepgoing=@keepgoing+@@rowcount
END
