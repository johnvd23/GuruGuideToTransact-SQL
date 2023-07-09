SELECT pub_name, COUNT(t.title_id) AS NumPublished
FROM publishers p LEFT JOIN titles t ON (p.pub_id = t.pub_id)
GROUP BY pub_name
