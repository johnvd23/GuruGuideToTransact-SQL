EXEC sp_MSforeachdb 'DBCC CHECKDB(?)'

EXEC sp_MSforeachdb @command1='PRINT "Listing ?"', @command2='USE ?; EXEC sp_dir'

-- Can't do this because both procs call spMSforeach_worker which uses the cursor hCForEach
--EXEC sp_MSforeachdb @command1='PRINT "Listing ?"', @command2='USE ?; EXEC sp_MSforeachtable @command1="EXEC sp_help ?"'
