DROP VIEW myauthors
GO
CREATE VIEW myauthors AS 
SELECT TOP 50 * 
FROM authors 
ORDER BY au_lname
GO