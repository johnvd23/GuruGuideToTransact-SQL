SELECT authors=
   CASE WHEN au_fname=(SELECT MIN(au_fname) FROM authors WHERE au_lname=a.au_lname) 
           THEN au_lname 
        ELSE '' 
        END+CHAR(13)+CHAR(9)+au_fname 
FROM authors a
