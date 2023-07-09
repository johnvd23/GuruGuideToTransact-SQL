SET NOCOUNT ON
CREATE TABLE #tempsamp
(SampDate datetime,
 Temp6am int,
 Temp6pm int)

INSERT #tempsamp VALUES ('19990101',44,32)
INSERT #tempsamp VALUES ('19990201',41,39)
INSERT #tempsamp VALUES ('19990301',48,56)
INSERT #tempsamp VALUES ('19990401',65,72)
INSERT #tempsamp VALUES ('19990501',59,82)
INSERT #tempsamp VALUES ('19990601',47,84)
INSERT #tempsamp VALUES ('19990701',61,92)
INSERT #tempsamp VALUES ('19990801',56,101)
INSERT #tempsamp VALUES ('19990901',59,78)
INSERT #tempsamp VALUES ('19991001',54,74)
INSERT #tempsamp VALUES ('19991101',47,67)
INSERT #tempsamp VALUES ('19991201',32,41)

SELECT HiTemp=CASE WHEN Temp6am > Temp6pm THEN Temp6am ELSE Temp6pm END 
FROM #tempsamp
ORDER BY HiTemp
GO
DROP TABLE #tempsamp

