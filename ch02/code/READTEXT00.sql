DECLARE @textptr binary(16)

BEGIN TRAN
SELECT @textptr=TEXTPTR(pr_info) 
FROM pub_info (HOLDLOCK)
WHERE pub_id='1389'

READTEXT pub_info.pr_info @textptr 29 20
COMMIT TRAN
