SELECT title
FROM titles t
WHERE (SELECT SUM(qty) AS TotalSales FROM sales WHERE title_id=t.title_id) > 30
