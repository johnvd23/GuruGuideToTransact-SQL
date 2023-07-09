SELECT pub_name, (SELECT COUNT(*) FROM titles t WHERE t.pub_id=p.pub_id) AS NumPublished
FROM publishers p