SET NOCOUNT ON
CREATE TABLE #famousjaycees 
(jc varchar(15) UNIQUE,   -- Define a UNIQUE constraint
 occupation varchar(25),
 becamefamous int DEFAULT 0,
 notes text NULL)

INSERT #famousjaycees VALUES ('Julius Caesar','Military leader/dictator',-0045,'Took the Roman early retirement program')
IF (@@ERROR <>0) GOTO LIST
-- Now attempt to insert a duplicate value
INSERT #famousjaycees VALUES ('Julius Caesar','Military leader/dictator',-0045,'Took the Roman early retirement program')
IF (@@ERROR <>0) GOTO LIST
INSERT #famousjaycees VALUES ('Jesus Christ','Founded Christianity',0001,'Birth featured tellurian, ruminative, and tutelary visitors')
IF (@@ERROR <>0) GOTO LIST
INSERT #famousjaycees VALUES ('John Calhoun','Congressman',1825,'Served as VP under two U.S. presidents')
IF (@@ERROR <>0) GOTO LIST
INSERT #famousjaycees VALUES ('Joan Crawford','Actress',1923,'Appeared in everything from Grand Hotel to Trog')
IF (@@ERROR <>0) GOTO LIST
INSERT #famousjaycees VALUES ('James Cagney','Actor',1931,'This prototypical gangster made a dandy Yankee')
IF (@@ERROR <>0) GOTO LIST
INSERT #famousjaycees VALUES ('Jim Croce','Singer/songwriter',1972,'Would that time were in a bottle because you left us way too soon')
IF (@@ERROR <>0) GOTO LIST
INSERT #famousjaycees VALUES ('Joe Celko','Author/lecturer',1987,'Counts eating and living indoors among his favorite hobbies')

LIST:
SELECT * FROM #famousjaycees
GO
DROP TABLE #famousjaycees

