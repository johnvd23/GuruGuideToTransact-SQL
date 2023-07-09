SELECT title
FROM titles t
WHERE EXISTS(SELECT * FROM 
		(SELECT * FROM sales -- Not actually needed –- for illustration only
	 	UNION ALL
	 	SELECT NULL, NULL, NULL, 90, NULL, NULL) s 
 	     WHERE s.title_id=t.title_id AND s.qty>75)

