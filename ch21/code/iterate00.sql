SET NOCOUNT ON
CREATE TABLE iterate (I int identity(-100,1))

DECLARE @loop int
SET @loop=-100

WHILE (@loop<101) BEGIN
  INSERT iterate DEFAULT VALUES
  SET @loop=@loop+1
END

SELECT * FROM iterate
GO
--DROP TABLE iterate