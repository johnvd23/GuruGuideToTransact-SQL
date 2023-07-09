SELECT title
FROM (SELECT title_id, title FROM titles UNION ALL SELECT NULL, NULL) t
WHERE NOT EXISTS(SELECT * FROM sales s WHERE s.title_id=t.title_id)

