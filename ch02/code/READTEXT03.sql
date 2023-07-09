DECLARE @textptr binary(16), @blobsize int, @chunkindex int, @chunksize int
SET TEXTSIZE 64	-- Set really small for illustration purposes only

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT @textptr=TEXTPTR(pr_info), @blobsize=DATALENGTH(pr_info), @chunkindex=0,
@chunksize=CASE WHEN @@TEXTSIZE < @blobsize THEN @@TEXTSIZE ELSE @blobsize END
FROM pub_info
WHERE PATINDEX('%Algodata Infosystems%',pr_info)<>0

IF (@textptr IS NOT NULL) AND (@chunksize > 0)
WHILE (@chunkindex < @blobsize) AND (@@ERROR=0) BEGIN
  READTEXT pub_info.pr_info @textptr @chunkindex @chunksize
  SELECT @chunkindex=@chunkindex+@chunksize, 
	 @chunksize=CASE WHEN (@chunkindex+@chunksize) > @blobsize THEN @blobsize-@chunkindex ELSE @chunksize END
END
COMMIT TRAN
SET TEXTSIZE 0  -- Return to its default value (4096)
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- Back to its default (in a separate batch)
