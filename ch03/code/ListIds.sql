drop proc ListIdsByValue
go
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE ListIdsByValue @val int
AS
SET NOCOUNT ON
CREATE TABLE #values (k1 int identity, c1 int NULL)
INSERT #values (c1) VALUES (1)
INSERT #values (c1) VALUES (1)
INSERT #values (c1) VALUES (NULL)
INSERT #values (c1) VALUES (9)
SELECT * FROM #values WHERE c1=@val
DROP TABLE #values
GO
SET ANSI_NULLS ON
GO
exec ListIdsByValue @val=NULL
go