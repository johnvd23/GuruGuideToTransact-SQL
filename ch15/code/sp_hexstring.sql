USE master
IF (OBJECT_ID('dbo.sp_hexstring') IS NOT NULL)
  DROP PROC dbo.sp_hexstring
GO
CREATE PROC dbo.sp_hexstring @int varchar(10)=NULL, @hexstring varchar(30)=NULL OUT 
/*
Object: sp_hexstring
Description: Return an integer as a hexadecimal string






*/
AS
IF (@int IS NULL) OR (@int = '/?') GOTO Help
DECLARE @i int, @vb varbinary(30)
SELECT @i=CAST(@int as int), @vb=CAST(@i as varbinary)
EXEC master..xp_varbintohexstr @vb, @hexstring OUT
RETURN 0
Help:
EXEC sp_usage @objectname='sp_hexstring',
	@desc='Return an integer as a hexadecimal string',
   	@parameters='@int=Integer to convert, @hexstring=OUTPUT parm to receive hex string',
	@example='sp_hexstring "23", @myhex OUT',
	@author='Ken Henderson',
	@email='khen@khen.com',
	@version='1', @revision='0',
	@datecreated='19990802', @datelastchanged='19990815'
RETURN -1

GO

DECLARE @hex varchar(30)
EXEC sp_hexstring 10, @hex OUT
SELECT @hex

