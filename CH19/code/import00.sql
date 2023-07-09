SET NOCOUNT ON
USE pubs
DECLARE @rc int

-- First, export the rows
EXEC @rc=pubs..sp_exporttable @table='pubs..authors', @outputpath='d:\_temp\bcp\'
SELECT @rc AS RowsExported

-- Second, create a new table to store the rows
SELECT * INTO authorsimp FROM authors WHERE 1=0

-- Third, import the exported rows
EXEC pubs..sp_importtable @table='authorsimp', @inputpath='d:\_temp\bcp\',@inputname='authors.bcp'

SELECT COUNT(*) AS RowsLoaded FROM authorsimp
GO
DROP TABLE authorsimp
