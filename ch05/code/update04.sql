SET NOCOUNT ON
USE tempdb
CREATE TABLE famousjaycees 
(jc varchar(15) CHECK (LEFT(jc,3)<>'Joe'),    -- Establish a check constraint
 occupation varchar(25),
 becamefamous int DEFAULT 0,
 notes text NULL)

-- Assume the file was previously created
BULK INSERT famousjaycees FROM 'D:\GG_TS\famousjaycees.bcp'

-- Check that the miscreant is in place
SELECT * FROM famousjaycees

-- Now do the faux update
UPDATE famousjaycees
SET jc=jc, occupation=occupation, becamefamous=becamefamous, notes=notes

GO
DROP TABLE famousjaycees

