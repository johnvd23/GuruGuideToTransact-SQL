USE pubs
IF INDEXPROPERTY(OBJECT_ID('sales'),'qty','IsClustered') IS NOT NULL
  DROP INDEX sales.qty
IF INDEXPROPERTY(OBJECT_ID('publishers'),'pub_name','IsClustered') IS NOT NULL
  DROP INDEX publishers.pub_name
IF INDEXPROPERTY(OBJECT_ID('roysched'),'hirange','IsClustered') IS NOT NULL
  DROP INDEX roysched.hirange
USE Northwind
IF INDEXPROPERTY(OBJECT_ID('Customers'),'ContactName','IsClustered') IS NOT NULL
  DROP INDEX Customers.ContactName
GO
USE pubs
CREATE INDEX qty ON sales (qty)
CREATE INDEX pub_name ON publishers (pub_name)
CREATE INDEX hirange ON roysched (hirange)
USE Northwind
CREATE INDEX ContactName ON Customers (ContactName)
