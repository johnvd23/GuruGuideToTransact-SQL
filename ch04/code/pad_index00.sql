SET NOCOUNT OFF
USE pubs
IF INDEXPROPERTY(OBJECT_ID('titles'),'typeind','IsClustered') IS NOT NULL
    DROP INDEX titles.typeind
GO
CREATE INDEX typeind ON titles (type) WITH PAD_INDEX, FILLFACTOR = 10

