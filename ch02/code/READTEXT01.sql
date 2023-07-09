DECLARE @textptr binary(16), @patindex int, @patlength int

BEGIN TRAN
SELECT @textptr=TEXTPTR(pr_info), @patindex=PATINDEX('%Algodata Infosystems%',pr_info)-1,
@patlength=DATALENGTH('Algodata Infosystems')
FROM pub_info (HOLDLOCK)
WHERE PATINDEX('%Algodata Infosystems%',pr_info)<>0

READTEXT pub_info.pr_info @textptr @patindex @patlength
COMMIT TRAN
