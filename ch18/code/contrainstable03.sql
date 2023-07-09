SELECT R.RANK, E.LastName, E.FirstName, E.Notes
FROM Employees AS E JOIN
CONTAINSTABLE(Employees,*,'English OR French OR Italian OR German OR Flemish') AS R ON (E.EmployeeId=R.[KEY])
ORDER BY R.RANK DESC
