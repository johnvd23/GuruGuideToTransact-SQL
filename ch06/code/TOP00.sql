SELECT TOP 10 t.title, SUM(s.qty) AS TotalSales
FROM sales s JOIN titles t ON (s.title_id=t.title_id)
GROUP BY t.title
ORDER BY TotalSales DESC