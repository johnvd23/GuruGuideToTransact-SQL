SET NOCOUNT ON
DECLARE @numprocs varchar(10), @installedmemory varchar(20), @rootpath varchar(8000)

EXEC sp_getSQLregistry 'PhysicalMemory', @installedmemory OUT
EXEC sp_getSQLregistry 'NumberOfProcessors', @numprocs OUT
EXEC sp_getSQLregistry 'SQLRootPath', @rootpath OUT

SELECT @numprocs AS NumberOfProcessors, @installedmemory AS InstalledRAM, @rootpath AS RootPath

DECLARE @charset varchar(100), @sortorder varchar(100)
EXEC sp_getSQLregistry 'CharacterSet', @charset OUT

SELECT @charset AS CharacterSet

EXEC sp_getSQLregistry 'SortOrder', @sortorder OUT

SELECT @sortorder AS SortOrder
