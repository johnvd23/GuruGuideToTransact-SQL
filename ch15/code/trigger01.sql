ALTER TABLE sales
DISABLE TRIGGER SalesQty_INSERT_UPDATE

ALTER TABLE sales
ENABLE TRIGGER SalesQty_INSERT_UPDATE

ALTER TABLE sales
DISABLE TRIGGER ALL

ALTER TABLE sales
ENABLE TRIGGER ALL


