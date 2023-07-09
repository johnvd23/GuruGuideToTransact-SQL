DECLARE @objid int, @res int
SET @objid=OBJECT_ID('titles')
EXEC @res=sp_MStable_has_unique_index @objid
SELECT @res
