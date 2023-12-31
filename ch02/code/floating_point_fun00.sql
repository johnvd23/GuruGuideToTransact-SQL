SET NOCOUNT ON
CREATE TABLE #rand 
(k1 int identity, 
c1 float DEFAULT (
(CASE (CAST(RAND()+.5 AS int)*-1) WHEN 0 THEN 1 ELSE -1 END)*(CONVERT(int, RAND() * 100000) % 10000)*RAND()
)
)

INSERT #rand DEFAULT VALUES
INSERT #rand DEFAULT VALUES
INSERT #rand DEFAULT VALUES
INSERT #rand DEFAULT VALUES
INSERT #rand DEFAULT VALUES
INSERT #rand DEFAULT VALUES
INSERT #rand DEFAULT VALUES
INSERT #rand DEFAULT VALUES
INSERT #rand DEFAULT VALUES
INSERT #rand DEFAULT VALUES

SELECT * FROM #rand

SELECT SUM(c1) FROM #rand

SELECT * INTO #rand2 FROM #rand ORDER BY c1

SELECT SUM(c1) FROM #rand2

SELECT * INTO #rand3 FROM #rand2 ORDER BY ABS(c1)

SELECT SUM(c1) FROM #rand3

GO
DROP TABLE #rand, #rand2, #rand3
