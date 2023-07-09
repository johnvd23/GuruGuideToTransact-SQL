SELECT t.title
FROM titles t JOIN sales s ON (t.title_id=s.title_id)
GROUP BY t.title_id, t.title, t.ytd_sales, t.price
HAVING (t.ytd_sales+(SUM(s.qty)*t.price)) > 5000
