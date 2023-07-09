SELECT *
FROM CONTAINSTABLE(Employees,*,'English OR French OR Italian OR German OR Flemish')
ORDER BY RANK DESC
