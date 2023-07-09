SET NOCOUNT ON
CREATE TABLE DINOSAURS (OrderNo int PRIMARY KEY, OrderName varchar(30), PredecessorNo int NULL REFERENCES DINOSAURS (OrderNo))

INSERT DINOSAURS VALUES (1,'Amphibia',1)
INSERT DINOSAURS VALUES (2,'Cotylosauri',1)
INSERT DINOSAURS VALUES (3,'Pelycosauria',2)
INSERT DINOSAURS VALUES (4,'Therapsida',2)
INSERT DINOSAURS VALUES (5,'Chelonia',3)
INSERT DINOSAURS VALUES (6,'Sauropterygia',3)
INSERT DINOSAURS VALUES (7,'Ichthyosauria',3)
INSERT DINOSAURS VALUES (8,'Squamata',3)
INSERT DINOSAURS VALUES (9,'Thecodontia',3)
INSERT DINOSAURS VALUES (10,'Crocodilia',9)
INSERT DINOSAURS VALUES (11,'Pterosauria',9)
INSERT DINOSAURS VALUES (12,'Saurichia',9)
INSERT DINOSAURS VALUES (13,'Ornithischia',9)


CREATE TABLE #work (lvl int, OrderNo int)
CREATE TABLE #DINOSAURS (seq int identity, lvl int, OrderNo int)

DECLARE @lvl int, @curr int
SELECT TOP 1 @lvl=1, @curr=OrderNo FROM DINOSAURS WHERE OrderNo=PredecessorNo

INSERT INTO #work (lvl, OrderNo) VALUES (@lvl, @curr)

WHILE (@lvl > 0) BEGIN
  IF EXISTS(SELECT * FROM #work WHERE lvl=@lvl) BEGIN
    SELECT TOP 1 @curr=OrderNo FROM #work
    WHERE lvl=@lvl

    INSERT #DINOSAURS (lvl, OrderNo) VALUES (@lvl, @curr)

    DELETE #work
    WHERE lvl=@lvl and OrderNo=@curr

    INSERT #work
    SELECT @lvl+1, OrderNo
    FROM DINOSAURS
    WHERE PredecessorNo=@curr
    AND PredecessorNo <> OrderNo

    IF (@@ROWCOUNT > 0) SET @lvl=@lvl+1
  END ELSE
    SET @lvl=@lvl-1
END

SELECT 'Dinosaur Orders'=
REPLICATE(CHAR(9),lvl)+i.OrderName
FROM #DINOSAURS d JOIN DINOSAURS i ON (d.OrderNo=i.OrderNo)
ORDER BY seq

GO
DROP TABLE DINOSAURS, #DINOSAURS, #work
