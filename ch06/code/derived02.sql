SELECT s.state, st.stor_name,s.totalsales,Rank=COUNT(*)
FROM (SELECT t.state, t.stor_id, SUM(s.qty) AS TotalSales
	FROM sales s JOIN stores t ON (s.stor_id=t.stor_id)
	GROUP BY t.state, t.stor_id) s JOIN 
     (SELECT t.state, t.stor_id, SUM(s.qty) AS TotalSales
	FROM sales s JOIN stores t ON (s.stor_id=t.stor_id)
	GROUP BY t.state, t.stor_id) t ON (s.state=t.state)
     JOIN stores st ON (s.stor_id=st.stor_id)
WHERE s.totalsales <= t.totalsales 
GROUP BY s.state,st.stor_name,s.totalsales
HAVING COUNT(*) <=1
ORDER BY s.state, rank