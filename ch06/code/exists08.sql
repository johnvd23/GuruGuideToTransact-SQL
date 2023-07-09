SELECT CASE WHEN EXISTS(SELECT * FROM titleauthor where au_id=a.au_id) THEN 'True' ELSE 'False' END
FROM authors a
