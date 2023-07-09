SELECT SUM(qty) AS TotalSales
FROM sales
WHERE title_id=(SELECT MAX(title_id) FROM titles)
