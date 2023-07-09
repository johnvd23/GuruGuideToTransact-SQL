USE master
GO
IF OBJECT_ID('sp_dir') IS NOT NULL
    DROP PROC sp_dir
GO
CREATE PROCEDURE sp_dir @mask varchar(30) = '%', 
			@obtype varchar(2) = 'U', 
			@orderby varchar(8000)='/N' 
/*

Object: sp_dir
Description: Lists object catalog information similar to the OS DIR command.
Usage: sp_dir [@mask=name mask][,@obtype=object type][,@orderby=order switch[ ASC|DESC]]

@mask = pattern of object names to list (supports SQL wildcards); defaults to all objects
@obtype = type of objects to list (supports SQL wildcards); default to user tables

The following object types are supported:

 U  =  User tables
 S  =  System tables
 V  =  Views
 P  =  Stored procedures
 X  =  Extended procedures
 RF =  Replication filter stored procedures
 TR =  Triggers
 D  =  Default objects
 R  =  Rule objects
 T  =  User-defined data types

@orderby = column on which to sort listing.  
Can also include ASC or DESC to specify ascending/descending order.

The following orderings are supported:

/N  =  by Name
/R  =  by number of rows
/S  =  by total object size
/D  =  by date created
/A  =  by total size of data pages
/X  =  by total size of index pages
/U  =  by total size of unused pages
/L  =  by maximum row length
/O  =  by owner
Returns: (None)
Created by: Ken Henderson. Email: khen@khen.com
Version: 7.0
Example usage:  
  Parameters can be specified positionally, like so:

  sp_dir 'TRA%','U','/S'

  or by name, like so:

  sp_dir @mask='TRA%',@obtype='U',@orderby='/S DESC'

  You can also specify additional ordering columns with @orderby, like so:

  sp_dir @mask='TRA%',@obtype='U',@orderby='/S DESC, row_count, date_created DESC'

  All parameters are optional.  If no parameters are specified, the following
  command is executed:

  sp_dir '%','U','/N'
Created: 1992-06-12.  Last changed: 1999-07-02.

*/
AS
SET NOCOUNT ON

IF (@mask='/?') GOTO Help

SELECT @orderby=UPPER(@orderby)

DECLARE @execstr varchar(8000)

SET @execstr=
	"SELECT   -- Get regular objects
	' '=' ',
       	name=LEFT(o.name,30),
       	o.type,
       	date_created=            o.crdate,
       	row_count =              ISNULL(rows,0),
       	row_len_in_bytes=        ISNULL((SELECT SUM(length) FROM syscolumns WHERE id=o.id AND o.type in ('U','S')),0),
       	total_size_in_KB =       ISNULL((SELECT SUM(reserved) FROM sysindexes WHERE indid in (0, 1, 255) AND id = o.id),0)*2,
       	data_space_in_KB =       ISNULL(((SELECT SUM(dpages) FROM sysindexes WHERE indid < 2 AND id = o.id)+
                                        (SELECT ISNULL(SUM(used), 0) FROM sysindexes WHERE indid = 255 AND id = o.id)),0)*2,
       	index_space_in_KB =      ISNULL(((SELECT SUM(used) FROM sysindexes WHERE indid in (0, 1, 255) AND id = o.id) -
                                        ((SELECT SUM(dpages) FROM sysindexes WHERE indid < 2 AND id = o.id)+
                                        (SELECT ISNULL(SUM(used), 0) FROM sysindexes WHERE indid = 255 AND id = o.id))),0)*2,
       	unused_space_in_KB =     ISNULL(((SELECT SUM(reserved) FROM sysindexes WHERE indid in (0, 1, 255) AND id = o.id) -
                                        (SELECT SUM(used) FROM sysindexes WHERE indid in (0, 1, 255) AND id = o.id)),0)*2,
       	owner=                   USER_NAME(o.uid)
FROM sysobjects o,
sysindexes i
WHERE o.name like '"+@mask+"' AND o.type LIKE '"+@obtype+"'AND o.id*=i.id
AND i.indid<=1
UNION  ALL -- Get user-defined data types
SELECT ' ', LEFT(name,30), 'T', NULL, NULL, NULL, NULL, NULL, NULL, NULL, USER_NAME(uid)
FROM systypes
WHERE (usertype & 256)<>0
AND name LIKE '"+@mask
+"'AND 'T' LIKE '"+@obtype
+"' UNION ALL -- Get totals
SELECT 
'*',
'{TOTAL}',
       NULL,
       NULL,
       SUM(row_count),
       NULL,
       SUM(total_size_in_KB),
       SUM(data_space_in_KB),
       SUM(index_space_in_KB),
       SUM(unused_space_in_KB),
       NULL
FROM (SELECT 
       	row_count =              ISNULL(rows,0),
       	total_size_in_KB =       ISNULL((SELECT SUM(reserved) FROM sysindexes WHERE indid in (0, 1, 255) AND id = o.id),0)*2,
       	data_space_in_KB =       ISNULL(((SELECT SUM(dpages) FROM sysindexes WHERE indid < 2 AND id = o.id)+
                                        (SELECT ISNULL(SUM(used), 0) FROM sysindexes WHERE indid = 255 AND id = o.id)),0)*2,
       	index_space_in_KB =      ISNULL(((SELECT SUM(used) FROM sysindexes WHERE indid in (0, 1, 255) AND id = o.id) -
                                        ((SELECT SUM(dpages) FROM sysindexes WHERE indid < 2 AND id = o.id)+
                                        (SELECT ISNULL(SUM(used), 0) FROM sysindexes WHERE indid = 255 AND id = o.id))),0)*2,
       	unused_space_in_KB =     ISNULL(((SELECT SUM(reserved) FROM sysindexes WHERE indid in (0, 1, 255) AND id = o.id) -
                                        (SELECT SUM(used) FROM sysindexes WHERE indid in (0, 1, 255) AND id = o.id)),0)*2
	FROM sysobjects o,
	sysindexes i
	WHERE o.name like '"+@mask+"' AND o.type LIKE '"+@obtype+"' AND o.id*=i.id
	AND i.indid<=1) O
ORDER BY ' ',"+  -- Ensure that totals sort last
   CASE LEFT(@orderby,2)
   WHEN '/N' THEN 'name'+SUBSTRING(@orderby,3,8000)  -- Include ASC/DESC flag if there is one
   ELSE
     CASE LEFT(@orderby,2)
     WHEN '/D' THEN 'date_created' 
     WHEN '/S' THEN 'total_size_in_KB '
     WHEN '/R' THEN 'row_count'
     WHEN '/A' THEN 'data_space_in_KB'
     WHEN '/X' THEN 'index_space_in_KB'
     WHEN '/U' THEN 'unused_space_in_KB'
     WHEN '/L' THEN 'row_len_in_bytes'
     WHEN '/O' THEN 'owner'
     END+SUBSTRING(@orderby,3,8000)+',name'  -- Include name as secondary sort to resolve ties
   END

EXEC(@execstr)

RETURN 0

Help:
  EXEC sp_usage @objectname='sp_dir',
		@desc='Lists object catalog information similar to the OS DIR command.',
		@parameters='[@mask=name mask][,@obtype=object type][,@orderby=order switch[ ASC|DESC]]

@mask = pattern of object names to list (supports SQL wildcards); defaults to all objects
@obtype = type of objects to list (supports SQL wildcards); default to user tables

The following object types are supported:

 U  =  User tables
 S  =  System tables
 V  =  Views
 P  =  Stored procedures
 X  =  Extended procedures
 RF =  Replication filter stored procedures
 TR =  Triggers
 D  =  Default objects
 R  =  Rule objects
 T  =  User-defined data types

@orderby = column on which to sort listing.  
Can also include ASC or DESC to specify ascending/descending order.

The following orderings are supported:

/N  =  by Name
/R  =  by number of rows
/S  =  by total object size
/D  =  by date created
/A  =  by total size of data pages
/X  =  by total size of index pages
/U  =  by total size of unused pages
/L  =  by maximum row length
/O  =  by owner',
		@example=" 
  Parameters can be specified positionally, like so:

  sp_dir 'TRA%','U','/S'

  or by name, like so:

  sp_dir @mask='TRA%',@obtype='U',@orderby='/S DESC'

  You can also specify additional ordering columns with @orderby, like so:

  sp_dir @mask='TRA%',@obtype='U',@orderby='/S DESC, row_count, date_created DESC'

  All parameters are optional.  If no parameters are specified, the following
  command is executed:

  sp_dir '%','U','/N'",
@author='Ken Henderson', @email='khen@khen.com',
@version='7', @revision='0',
@datecreated='19920612', @datelastchanged='19990702'
RETURN -1

GO
