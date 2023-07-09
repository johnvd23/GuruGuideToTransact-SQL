SELECT R.RANK, E.LastName, E.FirstName, E.Notes
FROM Employees AS E JOIN
CONTAINSTABLE(Employees,*,'ISABOUT(English weight(.8), French weight(.1),
Italian weight(.2), German weight(.4), Flemish weight(0.0))') AS R ON (E.EmployeeId=R.[KEY])
ORDER BY R.RANK DESC
