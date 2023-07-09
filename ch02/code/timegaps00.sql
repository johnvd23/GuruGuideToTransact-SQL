SELECT t1.Employee,
 DATEADD(mi,1,t1.TimeOut) AS StartOfLoafing, 
 DATEADD(mi,-1,t2.TimeIn) AS EndOfLoafing, 
 DATEDIFF(mi,t1.TimeOut,t2.TimeIn) AS LengthOfLoafing
FROM timeclock t1 JOIN timeclock t2 ON (t1.Employee=t2.Employee)
WHERE (DATEADD(mi,1,t1.TimeOut) <= DATEADD(mi,-1,t2.TimeIn))
