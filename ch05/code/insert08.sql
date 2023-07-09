SET NOCOUNT ON
USE tempdb
CREATE TABLE famousjaycees 
(jc varchar(15),
 occupation varchar(25),
 becamefamous int DEFAULT 0,
 notes text NULL)

-- Assume the file was previously created
BULK INSERT famousjaycees FROM 'D:\GG_TS\famousjaycees.bcp'

SELECT * FROM famousjaycees
GO
DROP TABLE famousjaycees

