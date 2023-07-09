USE pubs
SELECT OBJECTPROPERTY(OBJECT_ID('table'),'ExecIsQuotedIdentOn') AS 'QuotedIdent'

USE Northwind
SELECT OBJECTPROPERTY(OBJECT_ID('listregionalemployees'),'ExecIsAnsiNullsOn') AS 'AnsiNulls'