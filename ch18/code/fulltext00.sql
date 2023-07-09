USE pubs
DECLARE @tablename sysname, @catalogname sysname, @indexname sysname, @columnname sysname

SET @tablename='pub_info'
SET @catalogname='pubsCatalog'
SET @indexname='UPKCL_pubinfo'
SET @columnname='pr_info'

EXEC sp_fulltext_database  'enable' -- STEP 1: Enable FTS for the database

EXEC sp_fulltext_catalog @catalogname, 'create' -- STEP 2: Create a full-text catalog

EXEC sp_fulltext_table @tablename,'create',@catalogname,@indexname -- STEP 3: Create a full-text index for the table

EXEC sp_fulltext_column @tablename, @columnname, 'add' -- STEP 4: Add the column to it

EXEC sp_fulltext_table @tablename,'activate' -- STEP 5: Activate the newly created FT index

EXEC sp_fulltext_catalog @catalogname, 'start_full' -- STEP 6: Populate the newly create FT catalog

