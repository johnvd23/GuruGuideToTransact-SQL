SELECT title
FROM titles WHERE title_id IN 	((SELECT title_id FROM sales WHERE qty>=75),
				 (SELECT title_id FROM sales WHERE qty=5), 
				  'PC'+REPLICATE('8',4))
