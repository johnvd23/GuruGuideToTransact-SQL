SET NOCOUNT ON
USE tempdb
CREATE TABLE testguid (c1 int identity)

EXEC sp_MSaddguidcolumn dbo,testguid

INSERT testguid DEFAULT VALUES
INSERT testguid DEFAULT VALUES

EXEC sp_MSaddguidindex dbo,testuid

SELECT * FROM testguid
GO
EXEC sp_MSunmarkreplinfo testguid,dbo
DROP TABLE testguid

