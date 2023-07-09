SELECT title
FROM titles t
WHERE NOT EXISTS(SELECT * FROM (SELECT * FROM sales 
				UNION ALL SELECT NULL, NULL, NULL, NULL, NULL, NULL) s 
		 WHERE s.title_id=t.title_id)
