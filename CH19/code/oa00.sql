DECLARE @rc int
EXEC @rc=sp_exporttable @table='pubs..authors', @outputpath='d:\_temp\bcp\'

SELECT RowsExported=@rc