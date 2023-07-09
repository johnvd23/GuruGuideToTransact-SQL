SET NOCOUNT ON

DECLARE Darryl CURSOR 	-- My brother Darryl
LOCAL
FOR SELECT stor_id, title_id, qty FROM sales

DECLARE Darryl CURSOR 	-- My other brother Darryl
GLOBAL
FOR SELECT au_lname, au_fname FROM authors

OPEN GLOBAL Darryl  
OPEN Darryl

FETCH GLOBAL Darryl
FETCH Darryl

CLOSE GLOBAL Darryl
CLOSE Darryl

DEALLOCATE GLOBAL Darryl
DEALLOCATE Darryl
