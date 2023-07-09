SET NOCOUNT ON
CREATE TABLE #famousjaycees 
(jcid int identity,	-- Here, we’ve added an identity column
 jc varchar(15),
 occupation varchar(25),
 becamefamous int DEFAULT 0,
 notes text NULL
 )

-- Notice that we omit it from list of values
INSERT #famousjaycees VALUES ('Julius Caesar','Military leader/dictator',DEFAULT,NULL)

SELECT * FROM #famousjaycees
GO
DROP TABLE #famousjaycees

