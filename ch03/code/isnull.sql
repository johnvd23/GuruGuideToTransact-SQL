declare @x int,@y int
set @x=5
set @y=2
SELECT ISNULL(CASE WHEN @x>=1 THEN NULL ELSE @x END,
       (SELECT COUNT(*) FROM authors))
