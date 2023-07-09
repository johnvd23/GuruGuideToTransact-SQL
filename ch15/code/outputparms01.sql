DECLARE @topsales int, @bestseller tid, @salescursor cursor
EXEC listsales @bestseller OUT, @topsales OUT, @salescursor OUT
SELECT @bestseller, @topsales

FETCH @salescursor
CLOSE @salescursor
DEALLOCATE @salescursor
