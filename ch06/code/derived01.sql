SET NOCOUNT ON
GO
CREATE TABLE #boxers
(Name varchar(30),
Weight float)

INSERT #boxers VALUES ('Glass Joe', 112)
INSERT #boxers VALUES ('Piston Hurricane', 176)
INSERT #boxers VALUES ('Bald Bull', 298)
INSERT #boxers VALUES ('Sugar Ray Ali', 151)
INSERT #boxers VALUES ('Leon Holmes', 119)
INSERT #boxers VALUES ('George Liston', 139)
INSERT #boxers VALUES ('Larry Leonard', 115)
INSERT #boxers VALUES ('Mike Mooncalf', 134)

SELECT B.Name, B.Weight, W.WeightClass
FROM #boxers B,
(SELECT 'flyweight' AS WeightClass, 0 AS LowBound, 112 AS HighBound
 UNION ALL
 SELECT 'bantomweight' AS WeightClass, 113 AS LowerBound, 118 AS HighBound
 UNION ALL
 SELECT 'featherweight' AS WeightClass, 119 AS LowerBound, 126 AS HighBound
 UNION ALL
 SELECT 'lightweight' AS WeightClass, 127 AS LowerBound, 135 AS HighBound
 UNION ALL
 SELECT 'welterweight' AS WeightClass, 136 AS LowerBound, 147 AS HighBound
 UNION ALL
 SELECT 'middleweight' AS WeightClass, 148 AS LowerBound, 160 AS HighBound
 UNION ALL
 SELECT 'light heavyweight' AS WeightClass, 161 AS LowerBound, 175 AS HighBound
 UNION ALL
 SELECT 'heavyweight' AS WeightClass, 195 AS LowerBound, 1000 AS HighBound) W
WHERE B.Weight BETWEEN W.LowBound and W.HighBound
ORDER BY W.LowBound
GO
DROP TABLE #boxers

