SET NOCOUNT ON
CREATE TABLE #samples
(k1	int identity,
 samp1	float DEFAULT (rand()*1000),
 samp2  float DEFAULT (rand()*1000)
)

INSERT #samples DEFAULT VALUES
INSERT #samples DEFAULT VALUES
INSERT #samples DEFAULT VALUES
INSERT #samples DEFAULT VALUES
INSERT #samples DEFAULT VALUES
INSERT #samples DEFAULT VALUES
INSERT #samples DEFAULT VALUES

SELECT * FROM #samples

UPDATE #samples 
SET 	samp1=samp2,
	samp2=samp1
/*
-- Not needed; just assign columns directly
DECLARE @swap float

UPDATE #samples 
SET 	@swap=samp1,
	samp1=samp2,
	samp2=@swap
*/
SELECT * FROM #samples

GO
DROP TABLE #samples
