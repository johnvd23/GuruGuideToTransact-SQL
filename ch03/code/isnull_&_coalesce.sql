declare @x int,@y int
set @x=5
set @y=2
select isnull(case when @x>=1 then NULL else @x end,case when @y<5 then @x*@y else 10 end)
SELECT COALESCE(@x / NULL, @x * NULL, @x+NULL, (SELECT COUNT(*) FROM authors), @y*2, @x)