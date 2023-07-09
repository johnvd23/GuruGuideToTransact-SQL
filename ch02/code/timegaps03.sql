SELECT ISNULL(t1.Employee,'***Total***') AS Employee,
 DATEADD(mi,1,t1.TimeOut) AS StartOfLoafing, 
 DATEADD(mi,-1,t2.TimeIn) AS EndOfLoafing,
 SUM(DATEDIFF(mi,t1.TimeOut,t2.TimeIn)) AS LengthOfLoafing
FROM timeclock T1 JOIN timeclock T2 ON (t1.Employee=t2.Employee)
WHERE (DATEADD(mi,1,t1.TimeOut)=
  (SELECT MAX(DATEADD(mi,1,t3.TimeOut)) 
   FROM timeclock T3
   WHERE (t3.Employee=t1.Employee)
   AND (DATEADD(mi,1,t3.TimeOut) <= DATEADD(mi,-1,t2.TimeIn))))
GROUP BY t1.Employee,
 DATEADD(mi,1,t1.TimeOut),
 DATEADD(mi,-1,t2.TimeIn),
 DATEDIFF(mi,t1.TimeOut,t2.TimeIn) WITH ROLLUP
HAVING ((GROUPING(DATEADD(mi,-1,t2.TimeIn))=0)
OR (GROUPING(DATEADD(mi,1,t1.TimeOut))+GROUPING(DATEADD(mi,-1,t2.TimeIn))=2))



