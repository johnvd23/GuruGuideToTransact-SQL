USE pubs
IF OBJECT_ID('dbo.listsales') IS NOT NULL
  DROP PROC dbo.listsales
GO
CREATE PROC dbo.listsales @bestseller tid OUT, @topsales int OUT, 
			  @salescursor cursor varying OUT
AS

SELECT @bestseller=bestseller, @topsales=totalsales
FROM (
	SELECT TOP 1 title_id AS bestseller, SUM(qty) AS totalsales
	FROM sales 
	GROUP BY title_id
	ORDER BY 2 DESC) bestsellers

DECLARE s CURSOR
LOCAL
FOR SELECT * FROM sales

OPEN s

SET @salescursor=s
RETURN(0)


