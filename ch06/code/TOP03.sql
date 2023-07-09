-- BAD SQL -- doesn't work as we'd like
SELECT TOP 1 t.state, t.stor_name, SUM(s.qty) AS TotalSales
FROM sales s JOIN stores t ON (s.stor_id=t.stor_id)
GROUP BY t.state, t.stor_name
ORDER BY TotalSales DESC, t.state, t.stor_name