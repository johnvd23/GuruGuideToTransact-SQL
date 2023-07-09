SET NOCOUNT ON
USE master
IF OBJECT_ID('dbo.sp_calcfactorial') IS NOT NULL
  DROP PROC dbo.sp_calcfactorial

DECLARE @typestr varchar(20)
SET @typestr='decimal('+CAST(@@MAX_PRECISION AS varchar(2))+',0)'

IF TYPEPROPERTY('bigd','precision') IS NOT NULL
  EXEC sp_droptype 'bigd'

EXEC sp_addtype 'bigd',@typestr  -- Add a custom type corresponding to the @@MAX_PRECISION variable

GO
CREATE PROC dbo.sp_calcfactorial @base_number bigd, @factorial bigd OUT
AS
SET NOCOUNT ON
DECLARE @previous_number bigd
   
IF ((@base_number>26) and (@@MAX_PRECISION<38)) OR (@base_number>32) BEGIN
  RAISERROR('Computing this factorial would exceed the server''s max. numeric precision of %d or the max. procedure nesting level of 32',16,10,@@MAX_PRECISION)
  RETURN(-1)
END

IF (@base_number<0) BEGIN
  RAISERROR('Can''t calculate negative factorials',16,10)
  RETURN(-1)
END

IF (@base_number<2) SET @factorial=1  -- Factorial of 0 or 1=1
ELSE BEGIN
  SET @previous_number=@base_number-1
  EXEC sp_calcfactorial @previous_number, @factorial OUT  -- Recursive call
  IF (@factorial=-1) RETURN(-1) -- Got an error, return
  SET @factorial=@factorial*@base_number
  IF (@@ERROR<>0) RETURN(-1) -- Got an error, return
END
RETURN(0)
GO

DECLARE @factorial bigd
EXEC sp_calcfactorial 26, @factorial OUT
SELECT @factorial
