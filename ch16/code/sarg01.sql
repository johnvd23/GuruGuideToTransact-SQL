USE pubs
-- Don't do this -- Bad T-SQL
SELECT city, state, zip FROM authors
WHERE au_lname+', '+au_fname='Dull, Ann'
