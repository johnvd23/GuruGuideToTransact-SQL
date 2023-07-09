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

CREATE TABLE #results (Guitarist varchar(15))

DECLARE @arrayvar varchar(8000)
DECLARE @i int, @l int
DECLARE c CURSOR FOR SELECT arraycol FROM #array

OPEN c
FETCH c INTO @arrayvar

WHILE (@@FETCH_STATUS=0) BEGIN
  SET @i=0
  SET @l=DATALENGTH(@arrayvar)/15
  WHILE (@i<@l) BEGIN
    INSERT #results SELECT SUBSTRING(@arrayvar,(@i*15)+1,15)
    SET @i=@i+1
  END
  FETCH c INTO @arrayvar
END
CLOSE c
DEALLOCATE c

SELECT * FROM #results
DROP TABLE #results
GO
DROP TABLE #array