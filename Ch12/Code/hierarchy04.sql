SET NOCOUNT ON
CREATE TABLE staff (employee int PRIMARY KEY, employee_name varchar(10), supervisor int NULL REFERENCES staff (employee))

INSERT staff VALUES (1,'GROUCHO',1)
INSERT staff VALUES (2,'CHICO',1)
INSERT staff VALUES (3,'HARPO',2)
INSERT staff VALUES (4,'ZEPPO',2)
INSERT staff VALUES (5,'MOE',1)
INSERT staff VALUES (6,'LARRY',5)
INSERT staff VALUES (7,'CURLY',5)
INSERT staff VALUES (8,'SHEMP',5)
INSERT staff VALUES (9,'JOE',8)
INSERT staff VALUES (10,'CURLY JOE',9)

SELECT Grunts=s.employee_name
FROM staff s
WHERE NOT EXISTS 
   (SELECT * FROM staff t WHERE t.supervisor=s.employee)
GO
DROP TABLE staff
