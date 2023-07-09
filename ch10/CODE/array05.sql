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

-- To clear the array for a given row (remove the WHERE clause to zap the entire table)
--UPDATE #array SET arraycol = '' WHERE k1=1

-- To clear the second element in each row
--UPDATE #array SET arraycol = LEFT(arraycol,1*15)+SPACE(1*15)+RIGHT(arraycol,DATALENGTH(arraycol)-(2*15))

-- To set the third element in each row to a particular value
--UPDATE #array SET arraycol = LEFT(arraycol,(2*15))+'MUDDY WATERS   '+RIGHT(arraycol,DATALENGTH(arraycol)-(3*15))

--To set the fourth element in a particular array
UPDATE #array 
SET arraycol = 
LEFT(arraycol,(3*15))+'MUDDY WATERS   '+
RIGHT(arraycol,CASE WHEN (DATALENGTH(arraycol)-(4*15))<0 THEN 0 ELSE DATALENGTH(arraycol)-(4*15) END) 
WHERE k1=2

SELECT 
	Element1=SUBSTRING(arraycol,(0*15)+1,15),
	Element2=SUBSTRING(arraycol,(1*15)+1,15),
	Element3=SUBSTRING(arraycol,(2*15)+1,15),
	Element4=SUBSTRING(arraycol,(3*15)+1,15),
	Element5=SUBSTRING(arraycol,(4*15)+1,15),
	Element6=SUBSTRING(arraycol,(5*15)+1,15)
FROM #array a

GO
DROP TABLE #array