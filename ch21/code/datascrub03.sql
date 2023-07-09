SET NOCOUNT ON
CREATE TABLE #datascrub 
(EmpID int identity, 
ICENumber1 varchar(14), 
ICENumber2 varchar(14))

INSERT #datascrub (ICENumber1, ICENumber2)
VALUES ('(101)555-1212','(101)555-1213')

INSERT #datascrub (ICENumber1, ICENumber2)
VALUES ('(201)555-1313','(201)555-1314')

INSERT #datascrub (ICENumber1, ICENumber2)
VALUES ('(301)555-1414','(301)5551415')

INSERT #datascrub (ICENumber1, ICENumber2)
VALUES ('(401)555-1515','(401)555-1516')

INSERT #datascrub (ICENumber1, ICENumber2)
VALUES ('(501)555-1616','501555-1617')

INSERT #datascrub (ICENumber1, ICENumber2)
VALUES ('(101)555-1211','(101)555-1213')

INSERT #datascrub (ICENumber1, ICENumber2)
VALUES ('(201)555-1313','(201)555-1314')

INSERT #datascrub (ICENumber1, ICENumber2)
VALUES ('(301)555-1414','(301)555-1415')

INSERT #datascrub (ICENumber1, ICENumber2)
VALUES ('(401)555-1515','(401)555-1516')

INSERT #datascrub (ICENumber1, ICENumber2)
VALUES ('(501)555-1616','(501)555-1617')

SELECT d.EmpId, d.ICENumber1, d.ICENumber2
FROM #datascrub d, (SELECT ICENumber1=REPLACE(REPLACE(REPLACE(t.ICENumber1,'-',''),'(',''),')',''), 
		           ICENumber2=REPLACE(REPLACE(REPLACE(t.ICENumber2,'-',''),'(',''),')','')
		    FROM #datascrub t
                    GROUP BY REPLACE(REPLACE(REPLACE(t.ICENumber1,'-',''),'(',''),')',''), 
		             REPLACE(REPLACE(REPLACE(t.ICENumber2,'-',''),'(',''),')','')
              	    HAVING COUNT(*) >=2) a
WHERE (REPLACE(REPLACE(REPLACE(d.ICENumber1,'-',''),'(',''),')','')
       =REPLACE(REPLACE(REPLACE(a.ICENumber1,'-',''),'(',''),')',''))
AND (REPLACE(REPLACE(REPLACE(d.ICENumber2,'-',''),'(',''),')','')
     =REPLACE(REPLACE(REPLACE(a.ICENumber2,'-',''),'(',''),')',''))

GO
DROP TABLE #datascrub