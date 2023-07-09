EXEC sp_MSforeachtable @command1='EXEC sp_help [?]'

EXEC sp_MSforeachtable @command1='PRINT "Listing ?"', @command2='SELECT * FROM ?',@whereand=' AND name like "title%"'
