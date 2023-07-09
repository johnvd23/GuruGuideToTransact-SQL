SELECT st.stor_name AS Store, t.type AS Type, SUM(qty) AS Sales 
FROM stores st JOIN sales s ON (st.stor_id=s.stor_id)
JOIN titles t ON (s.title_id=t.title_id)
GROUP BY st.stor_name, t.type
ORDER BY Store DESC, Type ASC
