SELECT 
	DATABASEPROPERTY('pubs','IsBulkCopy'), 
  	DATABASEPROPERTY('pubs','Version'), 
	DATABASEPROPERTY('pubs','IsAnsiNullsEnabled'),
	DATABASEPROPERTY('pubs','IsSuspect'),
	DATABASEPROPERTY('pubs','IsTruncLog')
