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

SELECT * FROM
(SELECT Free=MAX(CASE band WHEN 0 THEN CAST(title AS char(18)) ELSE NULL END),
       BadCompany=MAX(CASE band WHEN 1 THEN CAST(title AS char(21)) ELSE NULL END),
       TheFirm=MAX(CASE band WHEN 2 THEN CAST(title AS char(23)) ELSE NULL END),
       Solo=MAX(CASE band WHEN 3 THEN title ELSE NULL END)
      FROM #array 
      GROUP BY single) a
WHERE Free=BadCompany
OR Free=TheFirm
OR Free=Solo
OR BadCompany=TheFirm
OR BadCompany=Solo
OR TheFirm=Solo
GO
DROP TABLE #array