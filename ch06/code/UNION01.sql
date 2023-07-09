SELECT title_id AS Title_ID, t.type AS Type, b.typecode AS TypeCode
FROM titles t JOIN
(SELECT 'business' AS type, 0 AS typecode
UNION ALL
SELECT 'mod_cook' AS type, 1 AS typecode
UNION ALL
SELECT 'popular_comp' AS type, 2 AS typecode
UNION ALL
SELECT 'psychology' AS type, 3 AS typecode
UNION ALL
SELECT 'trad_cook' AS type, 4 AS typecode
UNION ALL
SELECT 'UNDECIDED' AS type, 5 AS typecode) b
ON (t.type = b.type)
ORDER BY TypeCode, Title_ID
