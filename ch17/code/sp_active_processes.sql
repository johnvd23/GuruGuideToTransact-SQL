USE master 
GO
IF OBJECT_ID('sp_active_processes') IS NOT NULL
	DROP PROC sp_active_processes
GO
CREATE PROC sp_active_processes
        @loginame varchar(30)=NULL, 	-- 'ACTIVEONLY' | spid | login name
        @duration int=5     		-- seconds to sample
/*

Object: sp_active_processes
Description: Shows system activity over a period of time
Usage: sp_active_processes [@loginame=login name | "ACTIVEONLY" | spid][, @duration=seconds to monitor]
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 4.2
Example usage:  
	sp_active_processes @duration=10 -- Monitors all processes for 10 seconds 
	sp_active_processes "ACTIVEONLY",30 -- Monitors all processes for 30 seconds, but only lists active ones
	sp_active_processes 34,5 -- Monitors spid 34 for 5 seconds
Created: 1991-05-11.  Last changed: 1999-07-02.

*/
AS
SET NOCOUNT ON

DECLARE @before datetime,
	@after datetime,
        @lowlogin sysname,
	@highlogin sysname,
	@spidlow int,
	@spidhigh int

SELECT  @lowlogin='', 
	@highlogin=REPLICATE('z',TYPEPROPERTY('sysname','Precision')),
	@spidlow=0,
	@spidhigh=32767

-- Crack @loginame
IF (@loginame<>'ACTIVEONLY') AND (@loginame IS NOT NULL) BEGIN    
  SELECT @lowlogin=@loginame, 
	 @highlogin=@loginame
  IF SUSER_SID(@lowlogin) IS NULL BEGIN
    IF @loginame LIKE "[0-9]%"
      SELECT @spidlow=CAST(@loginame AS int),
	     @spidhigh=CAST(@loginame AS int),
	     @lowlogin='',
	     @highlogin=REPLICATE('z',TYPEPROPERTY('sysname','Precision'))
      ELSE BEGIN
        PRINT 'Invalid loginame'
        PRINT CHAR(13)
        GOTO Help
      END
  END
END

-- Get locks
SELECT spid,'L1'=COUNT(*),'L2'=0 INTO #LCKS FROM  master..syslocks WHERE spid BETWEEN @spidlow AND @spidhigh GROUP BY spid 

-- Save off time
SELECT @before=CURRENT_TIMESTAMP

-- Get processes
SELECT SPID,LOGINAME,C1=CPU,C2=0,I1=PHYSICAL_IO,I2=0,CM1=CMD,CM2=CAST(' LOGGED OFF' AS CHAR(16)),S1=CAST(STATUS AS CHAR(16)),S2=SPACE(16),B2=0,dbid=0,HOSTNAME=SPACE(10)
INTO #PRCS FROM master..sysprocesses WHERE loginame BETWEEN @lowlogin AND @highlogin AND spid BETWEEN @spidlow AND @spidhigh

-- Wait for duration specified
DECLARE @WAITFORSTR varchar(30)
SET @WAITFORSTR='WAITFOR DELAY "'+CONVERT(char(8),DATEADD(ss,@duration,'19000101'),108)+'"'
EXEC(@WAITFORSTR)

-- Get the locks again
INSERT #LCKS SELECT DISTINCT spid,0,COUNT(*) FROM master..syslocks WHERE spid BETWEEN @spidlow AND @spidhigh GROUP BY spid

-- Save off the time again
SELECT  @after=CURRENT_TIMESTAMP

-- Get the processes a second time
INSERT #PRCS SELECT spid,loginame,0,CPU,0,PHYSICAL_IO,' ',CMD,' ',STATUS,BLOCKED,DBID,HOSTNAME FROM master..sysprocesses
WHERE loginame BETWEEN @lowlogin AND @highlogin AND spid BETWEEN @spidlow AND @spidhigh

-- Put an entry for every process in the locks work table
INSERT #LCKS SELECT DISTINCT spid,0,0 FROM #PRCS

-- Grab the blockers out of the process and lock work tables
SELECT SPID=B2,BLKING=STR(COUNT(*),4) 
INTO #BLK 
FROM #PRCS WHERE B2<>0 GROUP BY B2

INSERT #BLK 
SELECT DISTINCT l.spid,STR(0,4) FROM #LCKS l LEFT OUTER JOIN #BLK b ON (l.spid<>b.spid) WHERE b.spid IS NULL

-- Print report header
PRINT 'STATISTICS FOR '+@@SERVERNAME+' AS OF '+CAST(CURRENT_TIMESTAMP AS varchar)
PRINT 'ACTIVITY OF '+CASE WHEN @lowlogin=@highlogin THEN 'LOGIN '+@loginame ELSE UPPER(LEFT(ISNULL(@loginame,'ALL'),6))+' LOGINS' END+' FOR THE PAST '+CAST(DATEDIFF(SS,@before,@after) AS varchar)+' SECOND(S)'
PRINT CHAR(13)

-- Print report body
SELECT ' A'=CASE WHEN P.spid=@@spid THEN '*' ELSE ' ' END+
	CASE WHEN (L.L2<>L.L1)
	      OR (P.C2<>P.C1)
 	      OR (P.I2<>P.I1)
	      OR (P.CM1<>P.CM2)
	      OR (P.S1<>P.S2)
	    THEN 'A'
	    ELSE 'I'
	    END,
        SPID=STR(P.spid, 5),
        LOGIN=LEFT(P.loginame,20),
        HOST=P.HOSTNAME,
--	C1, C2, I1, I2, L1, L2, CM1, CM2, S1, S2,
        LOG_IO=STR(P.C2,10),
        ' +/-'=SUBSTRING('- +',SIGN(P.C2-P.C1)+2,1)+LTRIM(STR(P.C2 - P.C1,6)),
        '%Chg'=STR(CASE WHEN P.C1<>0 THEN (1.0*(P.C2-P.C1)/P.C1) ELSE 0 END*100,6,1),
        PHYS_IO=STR(P.I2,10),
        ' +/-'=SUBSTRING('- +',SIGN(P.I2-P.I1)+2,1)+LTRIM(STR(P.I2 - P.I1,6)),
        '%Chg'=STR(CASE WHEN P.I1<>0 THEN (1.0*(P.I2-P.I1)/P.I1) ELSE 0 END*100,6,1),
        LCKS=STR(L.L2,5),
        ' +/-'=SUBSTRING('- +',SIGN(L.L2-L.L1)+2,1)+LTRIM(STR(L.L2 - L.L1,6)),
        '%Chg'=STR(CASE WHEN L.L1<>0 THEN (1.0*(L.L2-L.L1)/L.L1) ELSE 0 END*100,6,1),
        BLK=STR(P.B2 ,4),
        BLKCNT=B.BLKING,
        COMMAND=P.CM2,
        STATUS=LEFT(P.S2,10),
        DB=DB_NAME(P.DBID)
FROM    (SELECT spid, 
        loginame=MAX(loginame),
        C1=SUM(C1),
        C2=SUM(C2),
        I1=SUM(I1),
        I2=SUM(I2),
        CM1=MAX(CM1),
	CM2=MAX(CM2),
        S1=MAX(S1),
	S2=MAX(S2),
        B2=MAX(B2),
	dbid=MAX(DBID), 
	hostname=MAX(HOSTNAME)
	FROM #PRCS
	GROUP BY spid) P,
	(SELECT  spid,
	L1=SUM(L1),
	L2=SUM(L2)
	FROM #LCKS 
	GROUP BY spid) L,
	#BLK B
WHERE   P.spid=L.spid
AND     P.spid=B.spid
AND   (@loginame<>'ACTIVEONLY'
OR     @loginame IS NULL
OR     L.L2<>L.L1
OR     P.C2<>P.C1 
OR     P.I2<>P.I1  
OR     P.CM1<>P.CM2
OR     P.S1<>P.S2)

-- Print report footer
PRINT CHAR(13)+'TOTAL PROCESSES: '+CAST(@@ROWCOUNT AS varchar)+CHAR(13)+'(A - ACTIVE, I - INACTIVE, * - THIS PROCESS.)'

-- Delete work tables
DROP TABLE #LCKS
DROP TABLE #PRCS
DROP TABLE #BLK
RETURN 0

Help:
EXEC sp_usage @objectname='sp_active_processes', @desc='Shows system activity over a period of time',
	@parameters='[@loginame=login name | "ACTIVEONLY" | spid][, @duration=seconds to monitor]',
	@example=' 
sp_active_processes @duration=10 -- Monitors all processes for 10 seconds 
sp_active_processes "ACTIVEONLY",30 -- Monitors all processes for 30 seconds, but only lists active ones
sp_active_processes 34,5 -- Monitors spid 34 for 5 seconds',
	@author='Ken Henderson',@email='khen@khen.com',
	@version='4',@revision='2',
	@datecreated='19910511',@datelastchanged='19990702'
RETURN -1

GO
