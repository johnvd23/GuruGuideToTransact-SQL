SET NOCOUNT ON
SELECT TableName=CAST(OBJECT_NAME(id) AS varchar(15)), IndexName=CAST(name AS VARCHAR(20)), KeyName=CAST(INDEX_COL(OBJECT_NAME(id),indid,1) AS VARCHAR(30))
FROM sysindexes

