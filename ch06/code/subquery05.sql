SELECT title
FROM titles t
WHERE title_id IN (SELECT s.title_id
		   FROM sales s
		   WHERE (t.ytd_sales+((SELECT SUM(s1.qty) FROM sales s1 WHERE s1.title_id=t.title_id)*t.price)) > 5000)
