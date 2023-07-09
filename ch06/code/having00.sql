SELECT title_id
FROM titles
WHERE type='business'
GROUP BY title_id, type
