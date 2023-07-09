DECLARE @res int
EXEC @res=sp_MSis_pk_col 'titles','title_id',1
SELECT @res