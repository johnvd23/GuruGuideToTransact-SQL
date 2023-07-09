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

CREATE TABLE #semifamousjaycees 
(jc varchar(15),
 occupation varchar(25),
 becamefamous int DEFAULT 0,
 notes text NULL)

INSERT #semifamousjaycees VALUES ('John Candy','Actor',1981,'Your melliferous life was all-too brief')
INSERT #semifamousjaycees VALUES ('John Cusack','Actor',1984,'Uttered, "Go that way, very fast"')
INSERT #semifamousjaycees VALUES ('Joan Cusack','Actress',1987,'Uncle Fester''s avaricious femme fatale')

UPDATE f
SET 	jc=s.jc,
	occupation=s.occupation,
	becamefamous=s.becamefamous,
	notes=s.notes
FROM #famousjaycees f JOIN #semifamousjaycees s ON (f.becamefamous=s.becamefamous)

SELECT * FROM #famousjaycees
GO
DROP TABLE #famousjaycees, #semifamousjaycees


