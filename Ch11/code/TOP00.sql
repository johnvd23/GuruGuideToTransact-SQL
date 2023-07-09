SET NOCOUNT ON
CREATE TABLE #1996_POP_ESTIMATE (Region char(7), State char(2), Population int)

INSERT #1996_POP_ESTIMATE VALUES ('West',   'CA',31878234)
INSERT #1996_POP_ESTIMATE VALUES ('South',  'TX',19128261)
INSERT #1996_POP_ESTIMATE VALUES ('North',  'NY',18184774)
INSERT #1996_POP_ESTIMATE VALUES ('South',  'FL',14399985)
INSERT #1996_POP_ESTIMATE VALUES ('North',  'NJ', 7987933)
INSERT #1996_POP_ESTIMATE VALUES ('East',   'NC', 7322870)
INSERT #1996_POP_ESTIMATE VALUES ('West',   'WA', 5532939)
INSERT #1996_POP_ESTIMATE VALUES ('Central','MO', 5358692)
INSERT #1996_POP_ESTIMATE VALUES ('East',   'MD', 5071604)
INSERT #1996_POP_ESTIMATE VALUES ('Central','OK', 3300902)

SELECT TOP 3 State, Region, Population
FROM #1996_POP_ESTIMATE
ORDER BY Population DESC
GO
DROP TABLE #1996_POP_ESTIMATE