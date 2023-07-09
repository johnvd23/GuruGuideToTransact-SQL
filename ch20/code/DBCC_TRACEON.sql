EXEC master..xp_logevent 99999,'CHECKPOINT before setting flag 3502',informational
CHECKPOINT
DBCC TRACEON(3604,3502)
DBCC TRACESTATUS(-1)
EXEC master..xp_logevent 99999,'CHECKPOINT after setting flag 3502',informational
CHECKPOINT
DBCC TRACEOFF(3604,3502)
DBCC TRACESTATUS(-1)
