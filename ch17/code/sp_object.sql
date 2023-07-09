USE master
GO
DROP PROC sp_object
GO
CREATE PROC sp_object @objectname sysname='%', @orderby varchar(8000)='1,2,3,4,5,6'
/*

Object: sp_object
Description: Returns detailed object info
Usage: sp_object [@objectname=name or mask of object(s) to list][,@orderby=ORDER BY clause for query]
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 7.0
Example: sp_object 'authors' 
Created: 1994-06-29.  Last changed: 1999-07-01.

*/
AS

IF (@objectname='/?') GOTO Help

EXEC("
SELECT Object=LEFT(O.Object,30), O.Type, 'SubType'=
CAST(CASE O.Type
	WHEN 'Constraint' THEN 
		CASE	WHEN OBJECTPROPERTY(id,'IsCheckCnst')=1 THEN 'Check Constraint'
		     	WHEN OBJECTPROPERTY(id,'IsForeignKey')=1 THEN 'Foreign Key Constraint'
		     	WHEN OBJECTPROPERTY(id,'IsPrimaryKey')=1 THEN 'Primary Key Constraint'
		     	WHEN OBJECTPROPERTY(id,'IsDefaultCnst')=1 THEN 'Default Constraint'
		     	WHEN OBJECTPROPERTY(id,'IsUniqueCnst')=1 THEN 'Unique Constraint'
		END
	WHEN 'Table' THEN
		CASE	WHEN OBJECTPROPERTY(id,'TableIsFake')=1 THEN 'Virtual'
			WHEN OBJECTPROPERTY(id,'IsSystemTable')=1 THEN 'System'
			WHEN OBJECTPROPERTY(id,'IsUserTable')=1 THEN 'User'
		END
	WHEN 'Trigger' THEN (SELECT ISNULL(SUBSTRING('Insert ',OBJECTPROPERTY(id,'ExecIsInsertTrigger'),7),'')+
				   ISNULL(SUBSTRING('Delete ',OBJECTPROPERTY(id,'ExecIsDeleteTrigger'),7),'')+
				   ISNULL(SUBSTRING('Update ',OBJECTPROPERTY(id,'ExecIsUpdateTrigger'),7),'')+
				   ISNULL(SUBSTRING('(Disabled) ',OBJECTPROPERTY(id,'ExecIsTriggerDisabled'),11),''))

	WHEN 'Stored Procedure' THEN
		CASE	WHEN OBJECTPROPERTY(id,'IsExtendedProc')=1 THEN 'Extended'
			WHEN OBJECTPROPERTY(id,'IsReplProc')=1 THEN 'Replication'
			ELSE 'User'
		END
	WHEN 'View' THEN
		CASE	WHEN OBJECTPROPERTY(id,'OwnerId')=3 THEN 'ANSI SQL-92'
			WHEN OBJECTPROPERTY(id, 'IsMSShipped')=1 THEN 'System'
		ELSE 'User'
		END
	WHEN 'User-defined Data Type' THEN
		(SELECT name+CASE WHEN name in ('char','varchar','nchar','nvarchar') THEN '('+CAST(TYPEPROPERTY(Object,'Precision') AS varchar)+')'
				  WHEN name in ('float','numeric','decimal','real','money','smallmoney') THEN '('+CAST(TYPEPROPERTY(Object,'Precision') AS varchar)+','+CAST(ISNULL(TYPEPROPERTY(Object,'Scale'),0) AS varchar)+')'
				  ELSE ''
			     END
		FROM systypes WHERE (type=id) AND (usertype & 256)=0 AND (name<>'sysname') AND prec=(SELECT MAX(prec) FROM systypes WHERE type=id))
	END
AS varchar(25)),
Owner=LEFT(USER_NAME(uid),25),
'System-Supplied'=CASE Type WHEN 'User-defined Data Type' THEN 'NO' -- Can't be, by definition
		  ELSE
			CASE OBJECTPROPERTY(id,'IsMSShipped') WHEN 0 THEN 'NO' ELSE 'YES' END
		  END,
Description=  SUBSTRING(
CASE 	WHEN O.Type='Constraint' THEN 
		(SELECT ISNULL(SUBSTRING(',Clustered Key,',OBJECTPROPERTY(id,'CnstIsClustKey'),30),'')+
				   ISNULL(SUBSTRING(',Column Constraint,',OBJECTPROPERTY(id,'CnstIsColumn'),30),'')+
				   ISNULL(SUBSTRING(',Disabled,',OBJECTPROPERTY(id,'CnstIsDisabled'),30),'')+
				   ISNULL(SUBSTRING(',Non-clustered key,',OBJECTPROPERTY(id,'CnstIsNonClustKey'),30),'')+
				   ISNULL(SUBSTRING(',NOT FOR REPLICATION,',OBJECTPROPERTY(id,'CnstIsNotRepl'),30),''))
	WHEN O.Type='Table' THEN
		(SELECT CASE WHEN OBJECTPROPERTY(id,'TableHasDeleteTrigger')=1 THEN ',# DELETE trig.:'+CAST(OBJECTPROPERTY(id,'TableDeleteTriggerCount') AS varchar) ELSE '' END+
			CASE WHEN OBJECTPROPERTY(id,'TableHasInsertTrigger')=1 THEN ',# INSERT trig.:'+CAST(OBJECTPROPERTY(id,'TableInsertTriggerCount') AS varchar) ELSE '' END+
			CASE WHEN OBJECTPROPERTY(id,'TableHasUpdateTrigger')=1 THEN ',# UPDATE trig.:'+CAST(OBJECTPROPERTY(id,'TableUpdateTriggerCount') AS varchar) ELSE '' END+

			',Full-text index?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasActiveFulltextIndex')*3)+1,3))+
			(CASE WHEN OBJECTPROPERTY(id, 'TableHasActiveFullTextIndex')=1 THEN 
				',Full-text catalog ID: '+ISNULL(CAST(OBJECTPROPERTY(id,'FulltextCatalogID') AS varchar),'(None)')+
				',Full-text key column: '+ISNULL((SELECT name FROM syscolumns WHERE id=id and colid=OBJECTPROPERTY(id,'TableFulltextKeyColumn')),'(None)')
			ELSE '' END)+

			',Primary key?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasPrimaryKey')*3)+1,3))+
			',Check cnst?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasCheckCnst')*3)+1,3))+
			',Default cnst?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasDefaultCnst')*3)+1,3))+
			',Foreign key?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasForeignKey')*3)+1,3))+
			',Foreign key ref?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasForeignRef')*3)+1,3))+
			',Unique cnst?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasUniqueCnst')*3)+1,3))+

			',Indexed?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasIndex')*3)+1,3))+
			',Clust. idx?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasClustIndex')*3)+1,3))+
			',Non-clust. idx?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasNonclustIndex')*3)+1,3))+

			',Identity?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasIdentity')*3)+1,3))+
			',ROWGUIDCOL?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasRowGUIDCol')*3)+1,3))+
			',Text col.?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasTextImage')*3)+1,3))+
			',Timestamp?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableHasTimestamp')*3)+1,3))+

			',Pinned?:'+RTRIM(SUBSTRING('NO YES',(OBJECTPROPERTY(id,'TableIsPinned')*3)+1,3)))
	WHEN O.Type = 'User-defined Data Type' THEN
		(SELECT	',Allows NULLs?:'+RTRIM(SUBSTRING('NO YES',(TYPEPROPERTY(Object,'AllowsNull')*3)+1,3))+
			ISNULL(',Uses ANSI trim?:'+RTRIM(SUBSTRING('NO YES',(TYPEPROPERTY(Object,'UsesANSITrim')*3)+1,3)),''))
	WHEN O.Type IN ('Trigger','Stored Procedure','View') THEN 
		(SELECT ',ANSI NULLS='+RTRIM(SUBSTRING('OFFON ',(OBJECTPROPERTY(id,'ExecIsAnsiNullsOn')*3)+1,3))+
			',Startup='+RTRIM(SUBSTRING('FALSETRUE ',(OBJECTPROPERTY(id,'ExecIsStartUp')*5)+1,5))+
			',QuotedIdent='+RTRIM(SUBSTRING('FALSETRUE ',(OBJECTPROPERTY(id,'ExecIsQuotedIdentOn')*5)+1,5)))
	END
,2,4000)
FROM (
SELECT Object=name,
	'Type'=
	CASE 
	WHEN OBJECTPROPERTY(id,'IsConstraint')=1 THEN 'Constraint'
	WHEN OBJECTPROPERTY(id,'IsDefault')=1 THEN 'Default Object'
	WHEN OBJECTPROPERTY(id,'IsProcedure')=1 OR OBJECTPROPERTY(id,'IsExtendedProc')=1 OR
	     OBJECTPROPERTY(id,'IsReplProc')=1 THEN 'Stored Procedure'
	WHEN OBJECTPROPERTY(id,'IsRule')=1 THEN 'Rule Object'
	WHEN OBJECTPROPERTY(id,'IsTable')=1 THEN 'Table'
	WHEN OBJECTPROPERTY(id,'IsTrigger')=1 THEN 'Trigger'
	WHEN OBJECTPROPERTY(id,'IsView')=1 THEN 'View'
	ELSE 'Unknown'
	END,
id,
uid
FROM sysobjects
WHERE name LIKE '"+@objectname+"'
UNION ALL
SELECT name, 'User-defined Data Type',
type, 
uid
FROM systypes
WHERE (usertype & 256)<>0
AND name LIKE '"+@objectname+"'
) O
ORDER BY "+@orderby
)

RETURN 0

Help:
EXEC sp_usage @objectname='sp_object', @desc='Returns detailed object info',
@parameters='[@objectname=name or mask of object(s) to list][,@orderby=ORDER BY clause for query]',
@author='Ken Henderson',@email='khen@khen.com',
@version='7',@revision='0',
@datecreated='19940629',@datelastchanged='19990701',
@example='sp_object ''authors'' '

RETURN -1

GO

