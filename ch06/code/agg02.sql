SELECT stor_id, title_id, SUM(qty) AS TotalSold
FROM sales
GROUP BY stor_id, title_id
ORDER BY 1,2
