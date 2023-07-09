USE pubs
DECLARE objects CURSOR
FOR 
SELECT name, deltrig, instrig, updtrig 
FROM sysobjects WHERE type='U' AND deltrig+instrig+updtrig>0

DECLARE @objname sysname, @deltrig int, @instrig int, @updtrig int,
	@deltrigname sysname, @instrigname sysname, @updtrigname sysname

OPEN objects
FETCH objects INTO @objname, @deltrig, @instrig, @updtrig

WHILE (@@FETCH_STATUS=0) BEGIN
  PRINT 'Triggers for object: '+@objname
  SELECT @deltrigname=OBJECT_NAME(@deltrig), @instrigname=OBJECT_NAME(@instrig), 
  	 @updtrigname=OBJECT_NAME(@updtrig)
  IF @deltrigname IS NOT NULL BEGIN
     PRINT 'Table: '+@objname+' Delete Trigger: '+@deltrigname
     EXEC sp_helptext @deltrigname
  END
  IF @instrigname IS NOT NULL BEGIN
     PRINT 'Table: '+@objname+' Insert Trigger: '+@instrigname
     EXEC sp_helptext @instrigname
  END
  IF @updtrigname IS NOT NULL BEGIN
     PRINT 'Table: '+@objname+' Update Trigger: '+@updtrigname
     EXEC sp_helptext @updtrigname
  END
  FETCH objects INTO @objname, @deltrig, @instrig, @updtrig
END

CLOSE objects
DEALLOCATE objects
