SELECT CASE GROUPING(st.stor_name) WHEN 0 THEN st.stor_name ELSE 'ALL' END AS Store, 
CASE GROUPING(t.type) WHEN 0 THEN t.type ELSE 'ALL TYPES' END AS Type,
SUM(s.qty) AS TotalSold
FROM sales s JOIN titles t ON (s.title_id=t.title_id)
JOIN stores st ON (s.stor_id=st.stor_id)
GROUP BY st.stor_name, t.type WITH CUBE

