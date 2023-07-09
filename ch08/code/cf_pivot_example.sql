SET NOCOUNT ON
CREATE TABLE #YEARLY_SALES
(SalesYear smalldatetime,
 Sales money)

INSERT #YEARLY_SALES VALUES ('19990101',86753.09)
INSERT #YEARLY_SALES VALUES ('20000101',34231.12)
INSERT #YEARLY_SALES VALUES ('20010101',67983.56)

SELECT 
  "1999"=SUM(Sales*(1-abs(sign(YEAR(SalesYear)-1999)))),
  "2000"=SUM(Sales*(1-abs(sign(YEAR(SalesYear)-2000)))),
  "2001"=SUM(Sales*(1-abs(sign(YEAR(SalesYear)-2001))))
FROM #YEARLY_SALES
GO
DROP TABLE #YEARLY_SALES