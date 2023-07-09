SELECT title, 
(SELECT SUM(qty) FROM sales WHERE title_id=t.title_id) AS TotalSales 
FROM titles t
