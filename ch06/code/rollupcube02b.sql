SELECT CASE GROUPING(s3.stor_name) WHEN 0 THEN s3.stor_name ELSE 'ALL' END AS Store, 
CASE GROUPING(s3.type) WHEN 0 THEN s3.type ELSE 'ALL TYPES' END AS Type,
SUM(s3.qty) AS TotalSold
FROM
	(SELECT DISTINCT s1.stor_name, s2.type, 0 AS qty
	FROM
	(SELECT st.stor_name, 
	t.type,
	SUM(s.qty) AS qty
	FROM sales s JOIN titles t ON (s.title_id=t.title_id)
	JOIN stores st ON (s.stor_id=st.stor_id)
	GROUP BY st.stor_name, t.type) s1
	CROSS JOIN
	(SELECT st.stor_name, 
	t.type,
	SUM(s.qty) AS qty
	FROM sales s JOIN titles t ON (s.title_id=t.title_id)
	JOIN stores st ON (s.stor_id=st.stor_id)
	GROUP BY st.stor_name, t.type) s2
	UNION ALL
	SELECT st.stor_name AS Store, 
	t.type AS Type,
	SUM(s.qty) AS qty
	FROM sales s JOIN titles t ON (s.title_id=t.title_id)
	JOIN stores st ON (s.stor_id=st.stor_id)
	GROUP BY st.stor_name, t.type) s3
GROUP BY s3.stor_name, s3.type WITH CUBE







