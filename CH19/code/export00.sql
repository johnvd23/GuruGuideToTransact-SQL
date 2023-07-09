USE pubs
DECLARE @rc int
EXEC @rc=pubs..sp_exporttable @table='pubs..authors', @outputpath='d:\_temp\bcp\'
SELECT RowsExported=@rc
