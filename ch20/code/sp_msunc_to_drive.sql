DECLARE @path sysname
EXEC sp_MSunc_to_drive '\\PYTHIA\C$\', 'PYTHIA',@path OUT
SELECT @path
