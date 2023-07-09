SET NOCOUNT ON
CREATE TABLE #famousjaycees 
(jc varchar(15),
 occupation varchar(25),
 becamefamous int DEFAULT 0,
 notes text NULL)

INSERT #famousjaycees VALUES ('Julius Caesar','Military leader/dictator',DEFAULT,NULL)

SELECT * FROM #famousjaycees
GO
DROP TABLE #famousjaycees

