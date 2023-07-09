USE northwind
EXEC sp_dboption 'northwind','single',true
EXEC sp_fixindex 'northwind', 'sysobjects', 2
EXEC sp_dboption 'northwind','single',false
