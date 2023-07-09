SELECT type, COUNT(*) AS number
FROM titles
WHERE type IN ('psychology','mod_cook','UNDECIDED')
GROUP BY type
ORDER BY number DESC