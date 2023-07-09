declare @tabid int, @typestr varchar(30)
SET @tabid=OBJECT_ID('authors')
EXEC sp_gettypestring @tabid, 1, @typestr OUT
SELECT @typestr