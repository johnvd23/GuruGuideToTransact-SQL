SELECT title
FROM titles WHERE title_id IN (SELECT title_id FROM sales)
