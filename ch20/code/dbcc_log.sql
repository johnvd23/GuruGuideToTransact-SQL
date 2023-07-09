CREATE TABLE #logrecs
(CurrentLSN varchar(30),
 Operation varchar(20),
 Context varchar(20),
 TransactionID varchar(20))

INSERT #logrecs
EXEC('DBCC LOG(''pubs'')')

SELECT * FROM #logrecs
GO
DROP TABLE #logrecs
