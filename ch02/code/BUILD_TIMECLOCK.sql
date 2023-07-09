USE tempdb
GO
DROP TABLE timeclock
GO
CREATE TABLE timeclock 
(Employee varchar(30),
 TimeIn smalldatetime,
 TimeOut smalldatetime
)
INSERT timeclock VALUES('Pythia','07:31:34','12:04:01')
INSERT timeclock VALUES('Pythia','12:45:10','17:32:49')
INSERT timeclock VALUES('Dionysus','9:31:29','10:46:55')
INSERT timeclock VALUES('Dionysus','10:59:32','11:39:12')
INSERT timeclock VALUES('Dionysus','13:05:16','14:07:41')
INSERT timeclock VALUES('Dionysus','14:11:49','14:57:02')
INSERT timeclock VALUES('Dionysus','15:04:12','15:08:38')
INSERT timeclock VALUES('Dionysus','15:10:31','16:13:58')
INSERT timeclock VALUES('Dionysus','16:18:24','16:58:01')
