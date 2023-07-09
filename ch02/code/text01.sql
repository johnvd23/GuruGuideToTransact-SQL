DROP PROC inserttext
GO
CREATE PROCEDURE inserttext @instext text
AS
SET NOCOUNT ON 

SELECT @instext AS 'Inserting'

CREATE TABLE #testnotes (k1 int identity, notes text)

INSERT #testnotes (notes) VALUES (@instext)

SELECT DATALENGTH(notes), *
FROM #testnotes 

DROP TABLE #testnotes

GO

EXEC inserttext 'TEST'
