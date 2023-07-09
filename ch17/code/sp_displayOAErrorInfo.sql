USE master
GO
IF OBJECT_ID('sp_hexadecimal') IS NOT NULL
  DROP PROC sp_hexadecimal
GO
CREATE PROCEDURE sp_hexadecimal @binvalue varbinary(255), @hexvalue varchar(255) OUTPUT AS
DECLARE @charvalue varchar(255), @i int, @length int, @hexstring char(16)

SELECT @charvalue = '0x'
SELECT @i = 1
SELECT @length = DATALENGTH(@binvalue)
SELECT @hexstring = '0123456789abcdef'

DECLARE @tempint int, @firstint int, @secondint int
WHILE (@i <= @length) BEGIN
  SELECT @tempint = CONVERT(int, SUBSTRING(@binvalue,@i,1))
  SELECT @firstint = FLOOR(@tempint/16)
  SELECT @secondint = @tempint - (@firstint*16)
  SELECT @charvalue = @charvalue +SUBSTRING(@hexstring, @firstint+1, 1)+SUBSTRING(@hexstring, @secondint+1, 1)
  SELECT @i = @i + 1
END

SELECT @hexvalue = @charvalue
GO
IF OBJECT_ID('sp_displayOAErrorinfo') IS NOT NULL
  DROP PROC sp_displayOAErrorinfo
GO
CREATE PROCEDURE sp_displayOAErrorinfo @object int, @hresult int AS

DECLARE @output varchar(255), @hrhex char(10), @hr int, @source varchar(255), @description varchar(255)

PRINT 'OLE Automation Error Information'
EXEC sp_hexadecimal @hresult, @hrhex OUTPUT
SET @output = '  HRESULT: ' + @hrhex
PRINT @output

EXEC @hr = sp_OAGetErrorInfo @object, @source OUTPUT, @description OUTPUT

IF (@hr = 0) BEGIN
  SET @output = '  Source: ' + @source
  PRINT @output
  SELECT @output = '  Description: ' + @description
  PRINT @output
END ELSE BEGIN
    PRINT '  sp_OAGetErrorInfo failed.'
    RETURN
END
go
