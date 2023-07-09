SET NOCOUNT ON
CREATE TABLE #array (k1 int identity (0,1), guitarist varchar(15))

INSERT #array (guitarist) VALUES('LES PAUL');
INSERT #array (guitarist) VALUES('BUDDY GUY');
INSERT #array (guitarist) VALUES('JEFF BECK');
INSERT #array (guitarist) VALUES('JOE SATRIANI');
INSERT #array (guitarist) VALUES('STEVE MILLER');
INSERT #array (guitarist) VALUES('EDDIE VAN HALEN');
INSERT #array (guitarist) VALUES('TOM SCHOLZ');
INSERT #array (guitarist) VALUES('STEVE VAI');
INSERT #array (guitarist) VALUES('ERIC CLAPTON');
INSERT #array (guitarist) VALUES('SLASH');
INSERT #array (guitarist) VALUES('JIMI HENDRIX');
INSERT #array (guitarist) VALUES('JASON BECKER');
INSERT #array (guitarist) VALUES('MICHAEL HARTMAN');

--To set the third element in the array
UPDATE #array
SET guitarist='JOHN GMUENDER'
WHERE k1=2

SELECT guitarist
FROM #array

GO
DROP TABLE #array