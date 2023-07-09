SELECT stor_id, COUNT(DISTINCT title_id) AS titles_sold, 
100*CAST(COUNT(DISTINCT title_id) AS float) / (SELECT COUNT(*) FROM titles) AS percent_of_total
FROM sales
GROUP BY stor_id
HAVING COUNT(DISTINCT title_id) > 2