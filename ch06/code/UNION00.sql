SELECT title_id, type
FROM titles
WHERE type='business'
UNION ALL
SELECT title_id, type
FROM titles
WHERE type='mod_cook'
