SET NOCOUNT ON
CREATE TABLE #testpad (c1 char(30))

SET ANSI_PADDING OFF

DECLARE @robertplant		char(20),
	@jimmypage		char(20),
	@johnbonham		char(20),
	@johnpauljones		char(20)

SET @robertplant=	'ROBERT PLANT   '
SET @jimmypage=		'JIMMY PAGE     '
SET @johnbonham=	'JOHN BONHAM    '
SET @johnpauljones=	'JOHN PAUL JONES'

INSERT #testpad VALUES (@robertplant)
INSERT #testpad VALUES (@jimmypage)
INSERT #testpad VALUES (@johnbonham)
INSERT #testpad VALUES (@johnpauljones)

SELECT DATALENGTH(c1) as LENGTH
FROM #testpad

SELECT *
FROM #testpad
WHERE c1 LIKE @johnbonham

GO
DROP TABLE #testpad
GO
