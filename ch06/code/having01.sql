SELECT title_id
FROM titles
GROUP BY title_id, type
HAVING type='business'
