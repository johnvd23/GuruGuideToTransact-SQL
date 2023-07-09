SELECT R.RANK, E.LastName, E.FirstName, E.Notes
FROM Employees AS E JOIN
FREETEXTTABLE(Employees,*,'BA BTS BS BCS degree') AS R ON (E.EmployeeId=R.[KEY])
ORDER BY R.RANK DESC
