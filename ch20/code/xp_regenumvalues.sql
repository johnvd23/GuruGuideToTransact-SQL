CREATE TABLE #reg 
(kv nvarchar(255) NOT NULL, 
 kvdata nvarchar(255) null)

INSERT #reg 
EXEC master..xp_regenumvalues 'HKEY_LOCAL_MACHINE',
'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer'

SELECT * FROM #reg
GO
DROP TABLE #reg