CREATE VIEW SalesByState AS
SELECT s.stor_id, SUM(s.qty) AS TotalSales, t.state 
FROM sales s JOIN stores t ON (s.stor_id=t.stor_id)
GROUP BY t.state, s.stor_id
GO
SELECT s.state, st.stor_name,s.totalsales,Rank=COUNT(*)
FROM SalesByState s JOIN SalesByState t ON (s.state=t.state)
     JOIN stores st ON (s.stor_id=st.stor_id)
WHERE s.totalsales <= t.totalsales 
GROUP BY s.state,st.stor_name,s.totalsales
HAVING COUNT(*) <=1
ORDER BY s.state, rank
GO
DROP VIEW SalesByState
GO
