SELECT title
FROM titles t
WHERE EXISTS(SELECT * FROM sales s WHERE s.title_id=t.title_id)
