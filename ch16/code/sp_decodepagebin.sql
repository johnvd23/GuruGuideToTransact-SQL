USE master
IF OBJECT_ID('sp_decodepagebin') IS NOT NULL
  DROP PROC sp_decodepagebin 
GO
CREATE PROC sp_decodepagebin @pagebin varchar(12), @file int=NULL OUT, @page int=NULL OUT
/*
Object: sp_decodepagebin
Description: Translates binary file/page numbers (like those in the sysindexes root, first, and FirstIAM columns) into integers
Usage: sp_decodepagebin @pagebin=binary(6) file/page number, @file=OUTPUT parm for file number, @page=OUTPUT parm for page number
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 1.2
Example: EXEC sp_decodepagebin "0x050000000100", @myfile OUT, @mypage OUT
Created: 1999-06-13.  Last changed: 1999-08-05.
*/
AS
DECLARE @inbin binary(6)
IF (@pagebin='/?') GOTO Help
SET @inbin=CAST(@pagebin AS binary(6))
SELECT	@file=(CAST(SUBSTRING(@inbin,6,1) AS int)*POWER(2,8))+(CAST(SUBSTRING(@inbin,5,1) AS int)), 
	@page=(CAST(SUBSTRING(@inbin,4,1) AS int)*POWER(2,24)) + 
	(CAST(SUBSTRING(@inbin,3,1) AS int)*POWER(2,16)) + 
	(CAST(SUBSTRING(@inbin,2,1) AS int)*POWER(2,8)) + 
	(CAST(SUBSTRING(@inbin,1,1) AS int))
from sysindexes
RETURN 0

Help:
EXEC sp_usage @objectname='sp_decodepagebin',
  	   @desc='Translates binary file/page numbers (like those in the sysindexes root, first, and FirstIAM columns) into integers',
	   @parameters='@pagebin=binary(6) file/page number, @file=OUTPUT parm for file number, @page=OUTPUT parm for page number',
	   @example='EXEC sp_decodepagebin "0x050000000100", @myfile OUT, @mypage OUT',
	   @author='Ken Henderson',
	   @email='khen@khen.com',
	   @version='1', @revision='2',
	   @datecreated='6/13/99', @datelastchanged='8/5/99'
RETURN -1
