SELECT CASE GROUPING(st.stor_name) WHEN 0 THEN st.stor_name ELSE 'ALL' END AS Store, 
CASE GROUPING(s.type) WHEN 0 THEN s.type ELSE 'ALL TYPES' END AS Type,
SUM(s.qty) AS TotalSold
FROM
	(SELECT DISTINCT st.stor_id, t.type, 0 AS qty
	FROM stores st CROSS JOIN titles t
	UNION ALL
	SELECT s.stor_id, t.type, s.qty FROM sales s JOIN titles t ON s.title_id=t.title_id) s
JOIN stores st ON (s.stor_id=st.stor_id)
GROUP BY st.stor_name, s.type WITH CUBE

