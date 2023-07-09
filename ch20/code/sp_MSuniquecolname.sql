DECLARE @uniquename sysname
EXEC sp_MSuniquecolname 'titles','title_id',@uniquename OUT
SELECT @uniquename