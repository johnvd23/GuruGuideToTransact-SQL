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

SELECT seq=IDENTITY(int), chartdepth=1, employee=o2.employee, supervisor=o1.employee
INTO #org_chart
FROM staff o1 INNER JOIN staff o2 ON (o1.employee=o2.supervisor)

WHILE (@@rowcount > 0) BEGIN
  INSERT #org_chart (chartdepth, employee, supervisor)
  SELECT DISTINCT o1.chartdepth+1, o2.employee, o1.supervisor
  FROM #org_chart o1 INNER JOIN #org_chart o2 ON (o1.employee=o2.supervisor)
  WHERE o1.chartdepth=(SELECT MAX(chartdepth) FROM #org_chart)
  AND o1.supervisor<>o1.employee
END

SELECT s.employee_name, supervises='supervises', e.employee_name
FROM #org_chart o INNER JOIN staff s ON (o.supervisor=s.employee)
INNER JOIN staff e ON (o.employee=e.employee)
WHERE o.supervisor<>o.employee
ORDER BY seq
GO
DROP TABLE staff, #org_chart
