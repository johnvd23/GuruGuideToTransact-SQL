BEGIN TRAN

SELECT title_id, type, price FROM titles

UPDATE titles
SET price=price*CASE title WHEN 'business' THEN 1.5
			   WHEN 'mod_cook' THEN .8
			   WHEN 'trad_cook' THEN .6
			   WHEN 'psychology' THEN .5
			   WHEN 'popular_comp' THEN 1.75
			   ELSE .75
		END

SELECT title_id, type, price FROM titles

GO
ROLLBACK TRAN

SELECT title_id, type, price FROM titles


