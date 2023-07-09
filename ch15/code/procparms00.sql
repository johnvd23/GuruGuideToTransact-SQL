EXEC sp_msforeachtable @command1='sp_help "?"', @replacechar = '?'

EXEC sp_msforeachtable 'sp_help "?"', '?'

EXEC sp_msforeachtable @command1='sp_help "?"', @replacechar = DEFAULT

EXEC sp_who @loginame=NULL
