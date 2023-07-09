DECLARE @res int, @uid int
SELECT @uid=SUSER_ID()
EXEC @res=sp_MScheck_uid_owns_anything @uid
SELECT @res