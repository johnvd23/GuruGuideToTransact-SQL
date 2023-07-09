CREATE TABLE #REPORT_LOG
(ReportLogId int identity PRIMARY KEY,
 ReportDate datetime DEFAULT GETDATE(),
 ReportUser varchar(30) DEFAULT USER_NAME(),
 ReportMachine varchar(30) DEFAULT HOST_NAME(),
 ReportName varchar(30) DEFAULT 'UNKNOWN')

INSERT #REPORT_LOG DEFAULT VALUES

SELECT * FROM #REPORT_LOG

DROP TABLE #REPORT_LOG  

