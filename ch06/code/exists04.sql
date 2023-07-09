SELECT title
FROM titles t
WHERE t.title_id IN (SELECT title_id FROM sales)
