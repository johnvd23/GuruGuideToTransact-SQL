USE pubs
SELECT * INTO authors2 FROM authors

EXEC sp_MSdrop_object @object_name='authors2'

IF OBJECT_ID('authors2') IS NULL
  PRINT 'It''s gone'
ELSE
  PRINT 'It''s b-a-a-c-c-k'
