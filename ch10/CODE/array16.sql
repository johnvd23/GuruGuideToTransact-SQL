SET NOCOUNT ON
CREATE TABLE #array (band int, single int, title varchar(30))

INSERT #array VALUES(0,0,'LITTLE BIT O'' LOVE');
INSERT #array VALUES(0,1,'FIRE AND WATER');
INSERT #array VALUES(0,2,'ALL RIGHT NOW');
INSERT #array VALUES(0,3,'THE HUNTER');
INSERT #array VALUES(1,0,'BAD COMPANY');
INSERT #array VALUES(1,1,'SHOOTING STAR');
INSERT #array VALUES(1,2,'FEEL LIKE MAKIN'' LOVE');
INSERT #array VALUES(1,3,'ROCK AND ROLL FANTASY');
INSERT #array VALUES(1,4,'BURNING SKY');
INSERT #array VALUES(2,0,'SATISFACTION GUARANTEED');
INSERT #array VALUES(2,1,'RADIOACTIVE');
INSERT #array VALUES(2,2,'MONEY CAN''T BUY');
INSERT #array VALUES(2,3,'TOGETHER');
INSERT #array VALUES(3,0,'GOOD MORNING LITTLE SCHOOLGIRL');
INSERT #array VALUES(3,1,'HOOCHIE-COOCHIE MAN');
INSERT #array VALUES(3,2,'MUDDY WATER BLUES');
INSERT #array VALUES(3,3,'THE HUNTER');

SELECT Free=MAX(CASE a.band WHEN 0 THEN CAST(a.title AS char(18)) ELSE NULL END),
       BadCompany=MAX(CASE a.band WHEN 1 THEN CAST(a.title AS char(21)) ELSE NULL END),
       TheFirm=MAX(CASE a.band WHEN 2 THEN CAST(a.title AS char(23)) ELSE NULL END),
       Solo=MAX(CASE a.band WHEN 3 THEN a.title ELSE NULL END)
      FROM #array a LEFT JOIN #array b ON (a.title=b.title)
      WHERE NOT (a.band=b.band AND a.single=b.single)
      GROUP BY a.single
GO
DROP TABLE #array