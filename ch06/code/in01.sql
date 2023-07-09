SELECT title
FROM titles WHERE title_id NOT IN (SELECT title_id FROM sales)
