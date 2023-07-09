SET NOCOUNT ON
GO
SELECT *
FROM 
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
ORDER BY LowBound
GO

