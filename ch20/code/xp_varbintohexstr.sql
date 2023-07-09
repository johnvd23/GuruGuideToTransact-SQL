DROP PROC sp_hex
GO
CREATE PROC sp_hex @i int, @hx varchar(30) OUT AS
DECLARE @vb varbinary(30)
SET @vb=CAST(@i as varbinary)
EXEC master..xp_varbintohexstr @vb, @hx OUT
GO
DECLARE @hex varchar(30)
EXEC sp_hex 343, @hex OUT
SELECT @hex