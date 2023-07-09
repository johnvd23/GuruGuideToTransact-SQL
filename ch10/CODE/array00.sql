SET NOCOUNT ON
CREATE TABLE #array (k1 int identity, arraycol varchar(8000))

INSERT #array (arraycol) VALUES ('LES PAUL       '+
    			      	 'BUDDY GUY      '+
			      	 'JEFF BECK      ')
INSERT #array (arraycol) VALUES ('STEVE MILLER   '+
			      	 'EDDIE VAN HALEN'+
				 'TOM SCHOLZ     ')
INSERT #array (arraycol) VALUES ('STEVE VAI      '+
				 'ERIC CLAPTON   '+
			      	 'SLASH          ')
SELECT Element1=SUBSTRING(arraycol,(0*15)+1,15),
       Element2=SUBSTRING(arraycol,(1*15)+1,15),
       Element3=SUBSTRING(arraycol,(2*15)+1,15)
FROM #array a
GO
DROP TABLE #array