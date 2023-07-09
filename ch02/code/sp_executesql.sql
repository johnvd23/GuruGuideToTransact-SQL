sp_executesql N'SELECT * FROM authors WHERE au_lname LIKE @au_lname', 
N'@au_lname varchar(40)',@au_lname='Green%'