SELECT st.stor_name, t.type, SUM(s.qty) AS TotalSold
FROM sales s JOIN titles t ON (s.title_id=t.title_id)
JOIN stores st ON (s.stor_id=st.stor_id)
GROUP BY st.stor_name, t.type
ORDER BY 1,2
