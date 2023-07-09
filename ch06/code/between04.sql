SET NOCOUNT ON
CREATE TABLE #engagements
(Engagement 		varchar(30),
 EngagementStart 	smalldatetime,
 EngagementEnd 		smalldatetime)

INSERT #engagements VALUES('Gulf of Tonkin','19640802','19640804')
INSERT #engagements VALUES('Da Nang','19650301','19650331')
INSERT #engagements VALUES('Tet Offensive','19680131','19680930')
INSERT #engagements VALUES('Bombing of Cambodia','19690301','19700331')
INSERT #engagements VALUES('Invasion of Cambodia','19700401','19700430')
INSERT #engagements VALUES('Fall of Saigon','19750430','19750430')

CREATE TABLE #soldier_tours
(Soldier	varchar(30),
 TourStart	smalldatetime,
 TourEnd	smalldatetime)

INSERT #soldier_tours VALUES('Henderson, Robert Lee','19700126','19700615')
INSERT #soldier_tours VALUES('Henderson, Kayle Dean','19690110','19690706')
INSERT #soldier_tours VALUES('Henderson, Isaac Lee','19680529','19680722')
INSERT #soldier_tours VALUES('Henderson, James D.','19660509','19670201')
INSERT #soldier_tours VALUES('Henderson, Robert Knapp','19700218','19700619')
INSERT #soldier_tours VALUES('Henderson, Rufus Q.','19670909','19680320')
INSERT #soldier_tours VALUES('Henderson, Robert Michael','19680107','19680131')
INSERT #soldier_tours VALUES('Henderson, Stephen Carl','19690102','19690914')
INSERT #soldier_tours VALUES('Henderson, Tommy Ray','19700713','19710303')
INSERT #soldier_tours VALUES('Henderson, Greg Neal','19701022','19710410')
INSERT #soldier_tours VALUES('Henderson, Charles E.','19661001','19750430')

SELECT Soldier+' served during the '+Engagement
FROM #soldier_tours, #engagements 
WHERE NOT ((TourEnd < EngagementStart) OR (TourStart > EngagementEnd))

GO
DROP TABLE #engagements, #soldier_tours
