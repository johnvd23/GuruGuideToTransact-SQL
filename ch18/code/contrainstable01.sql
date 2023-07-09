SELECT *
FROM CONTAINSTABLE(Employees,*,'ISABOUT(English weight(.8), German weight(.4), 
Italian weight(.2), French weight (.1))')
ORDER BY RANK DESC
