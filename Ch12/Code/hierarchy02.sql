SET NOCOUNT ON
GO
USE tempdb
GO

DROP PROC populate_hierarchy
GO
SET ANSI_NULLS OFF  -- Allows for equality comparisons with NULL (necessary
for the top boss -- Groucho in this case -- who has no supervisor)
GO
CREATE PROC populate_hierarchy @supervisor int AS
/*
  Inserts the employees managed by the specified supervisor into a
pre-existing temporary table based on the
  employee records contained in a pre-existing staff table.  Tables should
look like this:

  CREATE TABLE staff (
    employee int NOT NULL PRIMARY KEY,
    employee_name varchar(10) NULL ,
    supervisor int NULL
  )

  CREATE TABLE #org_chart
  (seq int identity PRIMARY KEY,
   chartdepth int,
   employee int,
   supervisor int)

  Note: This procedure calls itself recursively if it detects that an
employee manages other employees.

*/
DECLARE @employee int

DECLARE stf CURSOR LOCAL  -- Declare local cursor to avoid confusing caller
FOR SELECT employee FROM staff WHERE supervisor=@supervisor  -- Cursor lists
employees managed by supervisor

OPEN stf
FETCH stf INTO @employee
WHILE (@@FETCH_STATUS=0)
BEGIN
   INSERT #org_chart
   (chartdepth,
    employee,
    supervisor)
   VALUES (@@NESTLEVEL, @employee, @supervisor)  -- Use @@NESTLEVEL to track
chart depth (hierarchy level)

   IF EXISTS (SELECT s.employee, o.employee FROM staff s LEFT OUTER JOIN
#org_chart o ON (s.employee=o.employee)
              WHERE s.supervisor=@employee AND o.employee IS NULL)  -- If
this employee manages other employees
     EXEC populate_hierarchy @employee                                    -- call this proc recursively
   FETCH stf INTO @employee                                            -- Get the next employee
END
RETURN 0
GO
SET ANSI_NULLS ON
GO
/* end populate_hierarchy */

-- Create and populate the staff table
DROP TABLE staff
GO
CREATE TABLE staff (
  employee int NOT NULL PRIMARY KEY,
  employee_name varchar(10) NULL ,
  supervisor int NULL
)
GO

INSERT staff(employee, employee_name, supervisor) VALUES(1,'GROUCHO',NULL)
INSERT staff(employee, employee_name, supervisor) VALUES(2,'CHIC0',1)
INSERT staff(employee, employee_name, supervisor) VALUES(3,'HARPO',2)
INSERT staff(employee, employee_name, supervisor) VALUES(4,'ZEPP0',5)
INSERT staff(employee, employee_name, supervisor) VALUES(5,'MOE',1)
INSERT staff(employee, employee_name, supervisor) VALUES(6,'LARRY',5)
INSERT staff(employee, employee_name, supervisor) VALUES(7,'CURLY',5)
INSERT staff(employee, employee_name, supervisor) VALUES(8,'SHEMP',5)
INSERT staff(employee, employee_name, supervisor) VALUES(9,'JOE',8)
INSERT staff(employee, employee_name, supervisor) VALUES(10,'CURLY JOE',9)
GO

-- Create the temporary table
DROP TABLE #org_chart
GO
CREATE TABLE #org_chart
(seq int identity PRIMARY KEY,
chartdepth int,
employee int,
supervisor int)
GO

-- Now run the actual hierarchy query
DECLARE @supervisor int
SELECT @supervisor=NULL  -- Initialize supervisor to NULL because the top
boss isn't supervised by anyone

EXEC populate_hierarchy @supervisor

-- The original SELECT from the book (I decrement chartdepth by 1 in the
SELECT to adjust for @@NESTLEVEL)
SELECT
  OrgChart =
CONVERT(VARCHAR(50),REPLICATE(CHAR(9),chartdepth-1)+s.employee_name)
FROM (SELECT
  employee,
  seq=MIN(seq),
  chartdepth=MAX(chartdepth)
FROM #org_chart
GROUP BY employee) o INNER JOIN staff s ON (o.employee=s.employee)
ORDER BY o.seq
