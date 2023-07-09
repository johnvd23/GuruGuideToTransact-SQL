USE master
go
IF OBJECT_ID('sp_soundex_difference') IS NOT NULL
  DROP PROC sp_soundex_difference
go
CREATE PROCEDURE sp_soundex_difference @string1 varchar(50), @string2 varchar(50)=NULL, @difference int=NULL OUTPUT
/*

Object: sp_soundex_difference
Description: Returns the difference between the soundex codes of two strings
Usage: sp_soundex_difference @string1=first string to translate, @string2=second string to translate, @difference OUTPUT=difference between the two as an integer
Returns: An integer representing the degree of similarity -- 4=identical, 0=completely different
Created by: Ken Henderson. Email: khen@khen.com
Version: 7.0
Example: sp_soundex_difference "Rodgers", "Rogers"
Created: 1998-05-15.  Last changed: 1998-05-16.

*/

AS
IF (@string1='/?') GOTO Help

DECLARE @sx1 varchar(5), @sx2 varchar(5)

EXEC sp_soundex_alpha @string1, @sx1 OUTPUT
EXEC sp_soundex_alpha @string2, @sx2 OUTPUT

RETURN CASE 
	WHEN @sx1=@sx2 THEN 4
	WHEN LEFT(@sx1,3)=LEFT(@sx2,3) THEN 3
	WHEN LEFT(@sx1,2)=LEFT(@sx2,2) THEN 2
	WHEN LEFT(@sx1,1)=LEFT(@sx2,1) THEN 1
	ELSE 0
	END

Help:
EXEC sp_usage @objectname='sp_soundex_difference', @desc='Returns the difference between the soundex codes of two strings',
@parameters='@string1=first string to translate, @string2=second string to translate, @difference OUTPUT=difference between the two as an integer',
@returns='An integer representing the degree of similarity -- 4=identical, 0=completely different',
@author='Ken Henderson', @email='khen@khen.com',
@datecreated='19980515', @datelastchanged='19980516',
@version='7', @revision='0',
@example='sp_soundex_difference "Rodgers", "Rogers"'
RETURN -1

