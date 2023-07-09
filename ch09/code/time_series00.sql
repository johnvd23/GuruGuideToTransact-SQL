SET NOCOUNT ON
CREATE TABLE #valueset (k1 smalldatetime, c1 int)
INSERT #valueset (k1, c1) VALUES ('19990901',28)
INSERT #valueset (k1, c1) VALUES ('19991001',25)
INSERT #valueset (k1, c1) VALUES ('19991101',13)
INSERT #valueset (k1, c1) VALUES ('19991201',15)
INSERT #valueset (k1, c1) VALUES ('20000101',35)
INSERT #valueset (k1, c1) VALUES ('20000201',38)
INSERT #valueset (k1, c1) VALUES ('20000301',16)

SELECT v.k1, v.c1
FROM #valueset v JOIN #valueset a 
ON ((a.c1 >= v.c1) AND (a.k1 = DATEADD(mm,1,v.k1)))
OR ((a.c1 <= v.c1) AND (a.k1 = DATEADD(mm,-1,v.k1)))
GROUP BY v.k1, v.c1
GO
DROP TABLE #valueset
