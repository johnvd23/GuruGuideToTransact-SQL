SET NOCOUNT ON
CREATE TABLE #rand 
(k1 int identity, 
c1 float DEFAULT (
(CASE (CAST(RAND()+.5 AS int)*-1) WHEN 0 THEN 1 ELSE -1 END)*(CAST(RAND() * 100000 AS int) % 10000)*RAND()
),
c2 varchar(30) DEFAULT   REPLICATE(
			CHAR((CAST(RAND() * 10000 AS int) % 26) + 97)
			+CHAR((CAST(RAND() * 10000 AS int) % 26) + 97)
			+CHAR((CAST(RAND() * 10000 AS int) % 26) + 97)
			+CHAR((CAST(RAND() * 10000 AS int) % 26) + 97)
			+CHAR((CAST(RAND() * 10000 AS int) % 26) + 97),
			(CAST(RAND() * 10000 AS int) % 6)+1)

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

GO
DROP TABLE #rand

