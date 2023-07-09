SELECT *
FROM CONTAINSTABLE(Employees,*,'ISABOUT(English weight(.8), French weight(.1), 
Italian weight(.2), German weight(.4), Flemish weight(0.0))')
ORDER BY RANK DESC
