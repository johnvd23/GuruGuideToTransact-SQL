USE master
GO
IF OBJECT_ID('sp_soundex_alpha') IS NOT NULL
  DROP PROC sp_soundex_alpha
GO
CREATE PROCEDURE sp_soundex_alpha @instring varchar(50), @soundex varchar(50)=NULL OUTPUT
/*

Object: sp_soundex_alpha
Description: Returns the soundex of a string 
Usage: sp_soundex_alpha @instring=string to translate, @soundex OUTPUT=string in which to return soundex
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 7.0
Example: sp_soundex_alpha "Rodgers"
Created: 1998-05-15.  Last changed: 1998-05-16.

Notes:  Original source unknown.

Translation to Transact-SQL by Ken Henderson.

*/

AS
IF (@instring='/?') GOTO Help
DECLARE @workstr varchar(10)

SET @instring=UPPER(@instring)
SET @soundex=RIGHT(@instring,LEN(@instring)-1) -- Put all but the first char in a work buffer (we always return the first char)

SET @workstr='EIOUY' -- Replace vowels with A
WHILE (@workstr<>'') BEGIN
  SET @soundex=REPLACE(@soundex,LEFT(@workstr,1),'A')  
  SET @workstr=RIGHT(@workstr,LEN(@workstr)-1)
END

/*

Translate word prefixes using this table

From		To
MAC		MCC
KN		NN
K		C
PF		FF
SCH		SSS
PH		FF
 

*/

-- Re-affix first char
SET @soundex=LEFT(@instring,1)+@soundex

IF (LEFT(@soundex,3)='MAC') SET @soundex='MCC'+RIGHT(@soundex,LEN(@soundex)-3)
IF (LEFT(@soundex,2)='KN') SET @soundex='NN'+RIGHT(@soundex,LEN(@soundex)-2)
IF (LEFT(@soundex,1)='K') SET @soundex='C'+RIGHT(@soundex,LEN(@soundex)-1)
IF (LEFT(@soundex,2)='PF') SET @soundex='FF'+RIGHT(@soundex,LEN(@soundex)-2)
IF (LEFT(@soundex,3)='SCH') SET @soundex='SSS'+RIGHT(@soundex,LEN(@soundex)-3)
IF (LEFT(@soundex,2)='PH') SET @soundex='FF'+RIGHT(@soundex,LEN(@soundex)-2)

-- Remove first char
SET @instring=@soundex
SET @soundex=RIGHT(@soundex,LEN(@soundex)-1)

/*

Translate phonetic  prefixes (those following the first char) using this table:

From		To
DG		GG
CAAN		TAAN
D		T
NST		NSS
AV		AF
Q		G
Z		S
M		N
KN		NN
K		C
H		A (unless part of AHA)
AW		A
PH		FF
SCH		SSS

*/

SET @soundex=REPLACE(@soundex,'DG','GG')
SET @soundex=REPLACE(@soundex,'CAAN','TAAN')
SET @soundex=REPLACE(@soundex,'D','T')
SET @soundex=REPLACE(@soundex,'NST','NSS')
SET @soundex=REPLACE(@soundex,'AV','AF')
SET @soundex=REPLACE(@soundex,'Q','G')
SET @soundex=REPLACE(@soundex,'Z','S')
SET @soundex=REPLACE(@soundex,'M','N')
SET @soundex=REPLACE(@soundex,'KN','NN')
SET @soundex=REPLACE(@soundex,'K','C')

-- Translate H to A unless it's part of "AHA"
SET @soundex=REPLACE(@soundex,'AHA','~~~')
SET @soundex=REPLACE(@soundex,'H','A')
SET @soundex=REPLACE(@soundex,'~~~','AHA')

SET @soundex=REPLACE(@soundex,'AW','A')
SET @soundex=REPLACE(@soundex,'PH','FF')
SET @soundex=REPLACE(@soundex,'SCH','SSS')

-- Truncate ending A or S
IF (RIGHT(@soundex,1)='A' or RIGHT(@soundex,1)='S') SET @soundex=LEFT(@soundex,LEN(@soundex)-1)

-- Translate ending "NT" to "TT"
IF (RIGHT(@soundex,2)='NT') SET @soundex=LEFT(@soundex,LEN(@soundex)-2)+'TT'

-- Remove all As
SET @soundex=REPLACE(@soundex,'A','')

-- Re-affix first char
SET @soundex=LEFT(@instring,1)+@soundex

-- Remove repeating characters
DECLARE @c int
SET @c=65
WHILE (@c<91) BEGIN
  WHILE (CHARINDEX(char(@c)+CHAR(@c),@soundex)<>0)
    SET @soundex=REPLACE(@soundex,CHAR(@c)+CHAR(@c),CHAR(@c))
  SET @c=@c+1
end

SET @soundex=LEFT(@soundex,4)
IF (LEN(@soundex)<4) SET @soundex=@soundex+SPACE(4-LEN(@soundex)) -- Pad with spaces

RETURN 0

Help:
EXEC sp_usage @objectname='sp_soundex_alpha', @desc='Returns the soundex of a string',
@parameters='@instring=string to translate, @soundex OUTPUT=string in which to return soundex',
@author='Ken Henderson', @email='khen@khen.com',
@datecreated='19980515', @datelastchanged='19980516',
@version='7', @revision='0',
@example='sp_soundex_alpha "Rodgers"'
RETURN -1
