SET NOCOUNT ON
CREATE TABLE #array (k1 int identity, arraycol varchar(8000))

INSERT #array (arraycol) VALUES ('LES PAUL       '+
    			      	 'BUDDY GUY      '+
			      	 'JEFF BECK      '+
				 'JOE SATRIANI   ')
INSERT #array (arraycol) VALUES ('STEVE MILLER   '+
			      	 'EDDIE VAN HALEN'+
				 'TOM SCHOLZ     ')
INSERT #array (arraycol) VALUES ('STEVE VAI      '+
				 'ERIC CLAPTON   '+
			      	 'SLASH          '+
				 'JIMI HENDRIX   '+
				 'JASON BECKER   '+
				 'MICHAEL HARTMAN')

DECLARE @arrayvar varchar(8000), @select_stmnt varchar(8000)
DECLARE @k int, @i int, @l int, @c int
DECLARE c CURSOR FOR SELECT * FROM #array

SET @select_stmnt='SELECT '
SET @c=0

OPEN c
FETCH c INTO @k, @arrayvar

WHILE (@@FETCH_STATUS=0) BEGIN
  SET @i=0
  SET @l=DATALENGTH(@arrayvar)/15
  WHILE (@i<@l) BEGIN
    SELECT @select_stmnt=@select_stmnt+'Guitarist'+CAST(@c as varchar)+'='+QUOTENAME(RTRIM(SUBSTRING(@arrayvar,(@i*15)+1,15)),'"')+','
    SET @i=@i+1
    SET @c=@c+1
  END
  FETCH c INTO @k, @arrayvar
END
CLOSE c
DEALLOCATE c

SELECT @select_stmnt=LEFT(@select_stmnt,DATALENGTH(@select_stmnt)-1)

EXEC(@select_stmnt)

GO
DROP TABLE #array