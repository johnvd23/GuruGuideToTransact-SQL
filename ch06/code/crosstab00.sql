SET NOCOUNT ON
CREATE TABLE #crosstab (yr int, qtr int, sales money)

INSERT #crosstab VALUES (1999, 1, 44)
INSERT #crosstab VALUES (1999, 2, 50)
INSERT #crosstab VALUES (1999, 3, 52)
INSERT #crosstab VALUES (1999, 4, 49)
INSERT #crosstab VALUES (2000, 1, 50)
INSERT #crosstab VALUES (2000, 2, 51)
INSERT #crosstab VALUES (2000, 3, 48)
INSERT #crosstab VALUES (2000, 4, 45)
INSERT #crosstab VALUES (2001, 1, 46)
INSERT #crosstab VALUES (2001, 2, 53)
INSERT #crosstab VALUES (2001, 3, 54)
INSERT #crosstab VALUES (2001, 4, 47)

SELECT 
yr AS 'Year',
SUM(CASE qtr WHEN 1 THEN sales ELSE NULL END) AS Q1,
SUM(CASE qtr WHEN 2 THEN sales ELSE NULL END) AS Q2,
SUM(CASE qtr WHEN 3 THEN sales ELSE NULL END) AS Q3,
SUM(CASE qtr WHEN 4 THEN sales ELSE NULL END) AS Q4,
SUM(sales) AS Total
FROM #crosstab
GROUP BY yr

GO
DROP TABLE #crosstab
