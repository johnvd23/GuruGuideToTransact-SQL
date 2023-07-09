DECLARE @starttime datetime, @rows int
SET @starttime=GETDATE()
SET STATISTICS TIME ON
SELECT @rows=MAX(k1) FROM financial_median

SELECT 'There are '+CAST(@rows AS varchar)+' rows'

SELECT AVG(c1) AS "The financial median is" FROM financial_median 
WHERE k1 BETWEEN @rows / 2 AND (@rows / 2)+SIGN(@rows+1 % 2)
SET STATISTICS TIME OFF
SELECT 'It took '+CAST(DATEDIFF(ms,@starttime,GETDATE()) AS varchar)+' ms to compute the financial median'
