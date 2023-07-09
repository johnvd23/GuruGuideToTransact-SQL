DECLARE @au_id id
SELECT @au_id=(SELECT MAX(au_id) FROM titleauthor)

SELECT au_lname, au_fname
FROM authors
WHERE au_id BETWEEN (SELECT MIN(au_id) FROM titleauthor) AND ISNULL(@au_id,'ZZZZZZZZZZZ')
ORDER BY au_lname
