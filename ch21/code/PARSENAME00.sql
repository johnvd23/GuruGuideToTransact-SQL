DECLARE @objname varchar(30)
SET @objname='KHEN.master.dbo.sp_who'

SELECT  ServerName=CAST(PARSENAME(@objname,4) AS VARCHAR(15)), 
	DatabaseName=CAST(PARSENAME(@objname,3) AS VARCHAR(15)),
	OwnerName=CAST(PARSENAME(@objname,2) AS VARCHAR(15)),
	ObjectName=CAST(PARSENAME(@objname,1) AS VARCHAR(15))
