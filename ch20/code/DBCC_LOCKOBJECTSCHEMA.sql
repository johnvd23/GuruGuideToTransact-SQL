USE pubs
BEGIN TRAN

DBCC LOCKOBJECTSCHEMA('titleauthor')

--Comment out the COMMIT below and try a DDL modification to titleauthor 
--from another connection.  Your new connection will wait until this one
--commits.

COMMIT TRAN

