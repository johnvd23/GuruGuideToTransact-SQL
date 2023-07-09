SET ANSI_NULLS OFF
SELECT title
FROM titles t
WHERE t.title_id NOT IN (SELECT title_id FROM sales UNION SELECT NULL)
GO
SET ANSI_NULLS ON  -- Be sure to re-enable ANSI_NULLS