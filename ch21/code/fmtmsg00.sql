SET NOCOUNT ON
DECLARE @msg varchar(60), @msgid int, @pub_id varchar(10), @inprint int

SELECT @msgid=ISNULL(MAX(error)+1,999999) FROM master..sysmessages WHERE error > 50000

SELECT @pub_id=CAST(pub_id AS varchar), @inprint=COUNT(*) FROM titles GROUP BY pub_id -- Get the last one


BEGIN TRAN
exec sp_addmessage @msgid,1,'Publisher: %s has %d titles in print'
SET @msg=FORMATMESSAGE(@msgid,@pub_id,@inprint)
ROLLBACK TRAN

SELECT @msg
