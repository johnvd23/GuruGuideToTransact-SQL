SET NOCOUNT ON
CREATE TABLE #famousjaycees 
(jc varchar(15) DEFAULT '',
 occupation varchar(25) DEFAULT 'Rock star',
 becamefamous int DEFAULT 0,
 notes text NULL
 )

INSERT #famousjaycees DEFAULT VALUES

SELECT * FROM #famousjaycees
GO
DROP TABLE #famousjaycees

