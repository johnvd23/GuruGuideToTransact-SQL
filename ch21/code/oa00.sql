DECLARE @rc int
EXEC @rc=pubs..sp_exporttable @table='pubs..titleview', @outputpath='d:\_temp\bcp\'

SELECT RowsExported=@rc