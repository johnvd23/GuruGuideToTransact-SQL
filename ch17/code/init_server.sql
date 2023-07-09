/*

Object: INIT_SERVER.SQL
Description: Server initialization script
Created by: Ken Henderson. Email: khen@khen.com
Version: 7.0
Created: 1990-02-06.  Last changed: 1999-07-05.

*/
SET NOCOUNT ON
GO 
USE master
GO
DECLARE @username sysname, @password sysname, @server sysname
SET @username='sa'			-- Put the login you want to use here
SET @password=''			-- Put your password here (be sure this
					-- script is stored in a secure location!)
SET @server='(local)'			-- Put your server name here

-- Set template database options
PRINT 'Setting template database options'
EXEC master..sp_dboption 'model','auto update statistics',true
EXEC master..sp_dboption 'model','autoshrink',true
EXEC master..sp_dboption 'model','select into/bulkcopy',true
EXEC master..sp_dboption 'model','torn page detection',true

-- Add tempdate data types
PRINT 'Adding template data types'
IF EXISTS(SELECT * FROM model..systypes WHERE name = 'd')
  EXEC model..sp_droptype 'd'
EXEC model..sp_addtype 'd', 'decimal(10,2)','NULL'

-- Create backup devices and job steps for every database except tempdb
PRINT 'Creating backup devices and job steps for every database except tempdb'

DECLARE @rootpath sysname, @execstr varchar(8000), @dbname sysname, @job_id uniqueidentifier, @step_id int
-- Get SQL Server root installation path
EXEC sp_getSQLregistry @regkey='SQLRootPath', @regvalue=@rootpath OUTPUT, @username=@username, @password=@password, @server=@server

-- Delete the operator if it already exists
IF EXISTS(SELECT * FROM msdb..sysoperators WHERE name = 'Puck Feet')
  EXEC msdb..sp_delete_operator 'Puck Feet'

-- Add the operator
PRINT 'Setting up the job operator'
EXEC msdb..sp_add_operator @name = 'Puck Feet',
    @enabled = 1,
    @email_address ='[SMTP:puckfeet@dastard.com]',
    @pager_address = '8675309@pagerpros.com',
    @weekday_pager_start_time = 090000,
    @weekday_pager_end_time = 210000,
    @pager_days = 127,
    @netsend_address='NOT_HOCKEY'

-- Delete the job if it already exists
SELECT @job_id = job_id FROM msdb..sysjobs WHERE name='DailyBackup'
IF (@job_id IS NOT NULL) BEGIN
	-- Don't delete if it's a multi-server job
	IF (EXISTS (SELECT  * FROM msdb..sysjobservers WHERE (job_id=@job_id) AND (server_id <> 0))) BEGIN 
    		RAISERROR ('Unable to create job because there is already a multi-server job with the same name.',16,1)
	END ELSE  -- Delete the job 
		EXECUTE msdb..sp_delete_job @job_id=@job_id
  END 

-- Add the backup job
PRINT 'Adding the backup job'
EXEC msdb..sp_add_job @job_name = 'DailyBackup', 
    @enabled = 1,
    @description = 'Daily backup of all databases',
    @owner_login_name = 'sa',
    @notify_level_eventlog = 2,
    @notify_level_netsend = 2,
    @notify_netsend_operator_name='Puck Feet',
    @delete_level = 0

-- Schedule the job
PRINT 'Scheduling the job'
EXEC msdb..sp_add_jobschedule @job_name = 'DailyBackup', 
    @name = 'ScheduledBackup',
    @freq_type = 4, -- everyday
    @freq_interval = 1,
    @active_start_time = 101600

DECLARE Databases CURSOR FOR 
	SELECT CATALOG_NAME
	FROM INFORMATION_SCHEMA.SCHEMATA
	WHERE CATALOG_NAME <> 'tempdb' -- Omit system DBs
	ORDER BY CATALOG_NAME

OPEN Databases

FETCH Databases INTO @dbname
SET @step_id=0
WHILE (@@FETCH_STATUS=0) BEGIN
	IF NOT EXISTS(SELECT * FROM master..sysdevices WHERE name = @dbname+'back') BEGIN
		-- Create the data backup device
		PRINT 'Adding the data backup device for '+@dbname
		SET @execstr='EXEC sp_addumpdevice ''disk'', "'+@dbname+'back'+'", "'
		+@rootpath+'\backup\'+@dbname+'back.dmp"'
		EXEC(@execstr)
	END

	-- Add a job step to backup the database
	PRINT 'Adding the database backup job step for '+@dbname
	SET @execstr='EXEC msdb..sp_add_jobstep @job_name = ''DailyBackup'',
	@step_name = "'+'Backup of database: '+@dbname+'",
    	@subsystem = ''TSQL'', 
    	@command = ''BACKUP DATABASE '+@dbname+' TO '+@dbname+'back'', 
	@on_success_action=3'
	EXEC(@execstr)
	SET @step_id=@step_id+1

	-- Add one to backup its log
	IF (@dbname<>'master') AND (DATABASEPROPERTY(@dbname,'IsTruncLog')=0) BEGIN
		IF NOT EXISTS(SELECT * FROM master..sysdevices WHERE name = @dbname+'back') BEGIN
			-- Create the log backup device	
			PRINT 'Adding the log backup device for '+@dbname
			SET @execstr='EXEC sp_addumpdevice ''disk'', "'+@dbname+'logback'+'", "'
			+@rootpath+'\backup\'+@dbname+'logback.dmp"'
			EXEC(@execstr)
		END

		PRINT 'Adding the log backup job step for '+@dbname
		SET @execstr='EXEC msdb..sp_add_jobstep @job_name = ''DailyBackup'',
		@step_name = "'+'Backup of log for database: '+@dbname+'",
    		@subsystem = ''TSQL'',
    		@command = ''BACKUP LOG '+@dbname+' TO '+@dbname+'logback'', 
		@on_success_action=3'
		EXEC(@execstr)
		SET @step_id=@step_id+1
	END

	FETCH Databases INTO @dbname
END
CLOSE Databases
DEALLOCATE Databases

-- Set the last job step to quit with success
EXEC msdb..sp_update_jobstep @job_name='DailyBackup', @step_id=@step_id, @on_success_action=1

-- Associate the job with the job server
EXEC msdb..sp_add_jobserver @job_name='DailyBackup'

PRINT CHAR(13)+'Successfully initialized server'

GO
