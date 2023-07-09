USE pubs
BEGIN TRAN

-- Establish what the table looks like before the update (limit to 10 for brevity)
SELECT TOP 10 au_lname, au_fname, contract FROM authors ORDER BY au_id

UPDATE a
SET a.contract=0
FROM authors a JOIN (SELECT TOP 5 au_id FROM authors ORDER BY au_id) u ON (a.au_id=u.au_id)

-- Now show the table afterward (limit to 10 for brevity)
SELECT TOP 10 au_lname, au_fname, contract FROM authors ORDER BY au_id
GO
ROLLBACK TRAN



