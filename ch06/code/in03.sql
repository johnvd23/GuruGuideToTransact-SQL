SELECT title
FROM titles WHERE title_id IN (SELECT title_id FROM 
	(SELECT TOP 999999 title_id, COUNT(*) AS NumOccur FROM sales GROUP BY title_id ORDER BY NumOccur DESC) s)
