USE pubs
SELECT * 
FROM authors
WHERE LEFT(au_lname, 2) = 'Gr'
--WHERE au_lname LIKE 'Gr%'
