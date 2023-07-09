SELECT au_lname, au_fname
FROM authors
WHERE au_lname BETWEEN 'S' AND 'ZZ'
ORDER BY au_lname