USE tempdb
GO
CREATE PROC #test1 as
SELECT 1
GO
CREATE PROC #test2 as
SELECT 2
GO
CREATE PROC #test3 as
SELECT 3
GO

DROP PROC #test1, #test2, #test3
GO

CREATE VIEW test1 as
SELECT 1 '1'
GO
CREATE VIEW test2 as
SELECT 2 '2'
GO
CREATE VIEW test3 as
SELECT 3 '3'
GO

DROP VIEW test1, test2, test3
GO
