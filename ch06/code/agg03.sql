SELECT t.title
FROM titles t 
WHERE (SELECT COUNT(s.title_id) FROM sales s WHERE s.title_id=t.title_id)>1
