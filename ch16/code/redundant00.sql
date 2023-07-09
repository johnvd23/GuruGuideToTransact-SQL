ALTER TABLE titleauthor ADD au_lname varchar(40) NULL, au_fname varchar(20) NULL
GO
UPDATE t 
  SET au_lname=a.au_lname, 
      au_fname=a.au_fname
FROM titleauthor t JOIN authors a ON (t.au_id=a.au_id)
GO
SELECT * FROM titleauthor
GO
ALTER TABLE titleauthor DROP COLUMN au_lname
ALTER TABLE titleauthor DROP COLUMN au_fname
