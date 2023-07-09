SET NOCOUNT ON
CREATE TABLE #famousjaycees
(jc varchar(15),
 occupation varchar(25),
 becamefamous int DEFAULT 0,
 notes text NULL)

INSERT #famousjaycees VALUES ('Julius Caesar','Military leader/dictator',-0045,'Took the Roman early retirement program')
INSERT #famousjaycees VALUES ('Jesus Christ','Founded Christianity',0001,'Birth featured tellurian, ruminative, and tutelary visitors')
INSERT #famousjaycees VALUES ('John Calhoun','Congressman',1825,'Served as VP under two U.S. presidents')
INSERT #famousjaycees VALUES ('Joan Crawford','Actress',1923,'Appeared in everything from Grand Hotel to Trog')
INSERT #famousjaycees VALUES ('James Cagney','Actor',1931,'This prototypical gangster made a dandy Yankee')
INSERT #famousjaycees VALUES ('Jim Croce','Singer/songwriter',1972,'Would that time were in a bottle because you left us way too soon')
INSERT #famousjaycees VALUES ('Joe Celko','Author/lecturer',1987,'Counts eating and living indoors among his favorite hobbies')

CREATE TABLE #famousjaycees2
(jc varchar(15),
 occupation varchar(25),
 becamefamous int DEFAULT 0,
 notes text NULL)

INSERT #famousjaycees2
SELECT * FROM #famousjaycees
UNION ALL
SELECT 'Johnny Carson','Talk show host',1962,'Began career as The Great Carsoni'

SELECT * FROM #famousjaycees2
GO
DROP TABLE #famousjaycees, #famousjaycees2

