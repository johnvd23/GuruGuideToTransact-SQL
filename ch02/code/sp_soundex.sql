USE master
go
IF OBJECT_ID('sp_soundex') IS NOT NULL
  DROP PROC sp_soundex
go
CREATE PROCEDURE sp_soundex @instring varchar(50), @soundex varchar(50)=NULL OUTPUT
/*

Object: sp_soundex
Description: Returns the soundex of a string
Usage: sp_soundex @instring=string to translate, @soundex OUTPUT=string in which to return soundex
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 7.0
Example: sp_soundex "Rodgers"
Created: 1998-05-15.  Last changed: 1998-05-16.

Notes: Based on the soundex algorithm published by Robert Russell and Margaret O'Dell, 1918.

Translation to Transact-SQL by Ken Henderson.


*/
AS
IF (@instring='/?') GOTO Help

DECLARE @workstr varchar(10)

SET @instring=UPPER(@instring)
SET @soundex=RIGHT(@instring,LEN(@instring)-1) -- Put all but the first char in a work buffer (we always return the first char)

SET @workstr='AEHIOUWY' -- Remove these from the string
WHILE (@workstr<>'') BEGIN
  SET @soundex=REPLACE(@soundex,LEFT(@workstr,1),'')  
  SET @workstr=RIGHT(@workstr,LEN(@workstr)-1)
END

/*

Translate characters to numbers per the following table:

Char			Number
B,F,P,V			1
C,G,J,K,Q,S,X,Z		2
D,T			3
L			4
M,N			5
R			6

*/


SET @workstr='BFPV'
WHILE (@workstr<>'') BEGIN
  SET @soundex=REPLACE(@soundex,LEFT(@workstr,1),'1')
  SET @workstr=RIGHT(@workstr,LEN(@workstr)-1)
END

SET @workstr='CGJKQSXZ'
WHILE (@workstr<>'') BEGIN
  SET @soundex=REPLACE(@soundex,LEFT(@workstr,1),'2')
  SET @workstr=RIGHT(@workstr,LEN(@workstr)-1)
END

SET @workstr='DT'
WHILE (@workstr<>'') BEGIN
  SET @soundex=REPLACE(@soundex,LEFT(@workstr,1),'3')
  SET @workstr=RIGHT(@workstr,LEN(@workstr)-1)
END

SET @soundex=REPLACE(@soundex,'L','4')

SET @workstr='MN'
WHILE (@workstr<>'') BEGIN
  SET @soundex=REPLACE(@soundex,LEFT(@workstr,1),'5')
  SET @workstr=RIGHT(@workstr,LEN(@workstr)-1)
END

SET @soundex=REPLACE(@soundex,'R','6')


-- Now replace repeating digits (e.g., '11' or '22') with single digits
DECLARE @c int
SET @c=1
WHILE (@c<10) BEGIN
  SET @soundex=REPLACE(@soundex,CONVERT(char(2),@c*11),CONVERT(char(1),@c)) -- Multiply by 11 to produce repeating digits
  SET @c=@c+1
END  
SET @soundex=REPLACE(@soundex,'00','0')  -- Get rid of double zeros

SET @soundex=LEFT(@soundex,3)
WHILE (LEN(@soundex)<3) SET @soundex=@soundex+'0' -- Pad with zero

SET @soundex=LEFT(@instring,1)+@soundex -- Prefix first char and return
RETURN 0

Help:
EXEC sp_usage @objectname='sp_soundex', @desc='Returns the soundex of a string',
@parameters='@instring=string to translate, @soundex OUTPUT=string in which to return soundex',
@author='Ken Henderson', @email='khen@khen.com',
@datecreated='19980515', @datelastchanged='19980516',
@version='7', @revision='0',
@example='sp_soundex "Rodgers"'
RETURN -1
