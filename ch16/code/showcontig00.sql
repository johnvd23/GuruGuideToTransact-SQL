USE Northwind
DECLARE @oid int, @iid int
SET @oid=OBJECT_ID('Customers')
DBCC SHOWCONTIG(@oid)
