SET NOCOUNT ON
CREATE TABLE #valueset (k1 smalldatetime, c1 int)
insert #valueset (k1, c1) VALUES ('19990901',28)
insert #valueset (k1, c1) VALUES ('19991001',25)
insert #valueset (k1, c1) VALUES ('19991101',13)
insert #valueset (k1, c1) VALUES ('19991201',15)
insert #valueset (k1, c1) VALUES ('20000101',35)
insert #valueset (k1, c1) VALUES ('20000201',38)
insert #valueset (k1, c1) VALUES ('20000301',16)

SELECT
StartTime=CAST(v.k1 AS char(12)), EndTime=CAST(a.k1 AS char(12)),
StartVal=v.c1, EndVal=a.c1,
Change=SUBSTRING('- +',SIGN(a.c1-v.c1)+2,1)+CAST(ABS(a.c1-v.c1) AS varchar)
FROM 
  (SELECT k1, c1, ranking=(SELECT COUNT(DISTINCT k1) FROM #valueset u
   WHERE u.k1 <= l.k1) 
   FROM #valueset l) v LEFT OUTER JOIN 
  (SELECT k1, c1, ranking=(SELECT COUNT(DISTINCT k1) FROM #valueset u
   WHERE u.k1 <= l.k1) 
   FROM #valueset l) a
   ON (a.ranking=v.ranking+1)
WHERE a.k1 IS NOT NULL
GO
DROP TABLE #valueset
