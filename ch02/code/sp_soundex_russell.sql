USE master
go
IF OBJECT_ID('sp_soundex_russell') IS NOT NULL
  DROP PROC sp_soundex_russell
go
CREATE PROCEDURE sp_soundex_russell @instring varchar(50), @soundex varchar(50)=NULL OUTPUT
/*

Object: sp_soundex_russell
Description: Returns the soundex of a string (Russell optimization)
Usage: sp_soundex_russell @instring=string to translate, @soundex OUTPUT=string in which to return soundex
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 7.0
Example: sp_soundex_russell "Rodgers"
Created: 1998-05-15.  Last changed: 1998-05-16.

Notes:
Based on the soundex algorithm published by Robert Russell and Margaret O'Dell, 1918,
extended to incorporate Russell's optimizations for finer granularity.

*/
AS

IF (@instring='/?') GOTO Help
DECLARE @workstr varchar(10)

SET @instring=UPPER(@instring)
SET @soundex=RIGHT(@instring,LEN(@instring)-1) -- Put all but the first char in a work buffer (we always return the first char)

/*

Translate characters to numbers per the following table:

Char			Number
B,F,P,V			1
C,G,J,K,Q,S,X,Z		2
D,T			3
L			4
M,N			5
R			6
A,E,H,I,O,U,W,Y		9
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

SET @soundex=replace(@soundex,'L','4')

SET @workstr='MN'
WHILE (@workstr<>'') BEGIN
  SET @soundex=REPLACE(@soundex,LEFT(@workstr,1),'5')
  SET @workstr=RIGHT(@workstr,LEN(@workstr)-1)
END

set @soundex=replace(@soundex,'R','6')

SET @workstr='AEHIOUWY'
WHILE (@workstr<>'') BEGIN
  SET @soundex=REPLACE(@soundex,LEFT(@workstr,1),'9')  
  SET @workstr=RIGHT(@workstr,LEN(@workstr)-1)
END

-- Now replace repeating digits (e.g., '11' or '22') with single digits
DECLARE @c int
SET @c=1
WHILE (@c<10) BEGIN
  SET @soundex=REPLACE(@soundex,CONVERT(char(2),@c*11),CONVERT(char(1),@c)) -- Multiply by 11 to produce repeating digits
  SET @c=@c+1
END  
SET @soundex=REPLACE(@soundex,'00','0')  -- Get rid of double zeros
  
SET @soundex=REPLACE(@soundex,'9','')  -- Get rid of 9's

SET @soundex=LEFT(@soundex,3)
WHILE (LEN(@soundex)<3) SET @soundex=@soundex+'0' -- Pad with zero

SET @soundex=LEFT(@instring,1)+@soundex -- Prefix first char and return
RETURN 0

Help:
EXEC sp_usage @objectname='sp_soundex_russell', @desc='Returns the soundex of a string (Russell optimization)',
@parameters='@instring=string to translate, @soundex OUTPUT=string in which to return soundex',
@author='Ken Henderson', @email='khen@khen.com',
@datecreated='19980515', @datelastchanged='19980516',
@version='7', @revision='0',
@example='sp_soundex_russell "Rodgers"'
RETURN -1
