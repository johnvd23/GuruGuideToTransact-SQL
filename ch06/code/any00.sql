SELECT title
FROM titles WHERE title_id=ANY(SELECT title_id FROM sales)
