SELECT SUM(qty) AS TotalSales
FROM sales
WHERE title_id=(SELECT TOP 1 title_id FROM titles ORDER BY title_id DESC)
