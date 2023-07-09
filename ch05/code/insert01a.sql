SET NOCOUNT ON
CREATE TABLE #famousjaycees 
(jcid int identity,
 jc varchar(15),
 occupation varchar(25),
 becamefamous int DEFAULT 0,
 notes text NULL
 )

SET IDENTITY_INSERT #famousjaycees ON
INSERT #famousjaycees (jcid,jc,occupation,becamefamous,notes) 
VALUES (1,'Julius Caesar','Military leader/dictator',DEFAULT,NULL)
SET IDENTITY_INSERT #famousjaycees OFF

SELECT * FROM #famousjaycees
GO
DROP TABLE #famousjaycees

