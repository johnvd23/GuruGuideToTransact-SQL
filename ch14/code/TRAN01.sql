SET XACT_ABORT ON
SELECT TOP 5 au_lname, au_fname FROM authors ORDER BY au_lname, au_fname
BEGIN TRAN
DELETE authors
DELETE sales
SELECT TOP 5 au_lname, au_fname FROM authors ORDER BY au_lname, au_fname
ROLLBACK TRAN
PRINT 'End of batch -- never makes it here'
GO
SELECT TOP 5 au_lname, au_fname FROM authors ORDER BY au_lname, au_fname
SET XACT_ABORT ON
