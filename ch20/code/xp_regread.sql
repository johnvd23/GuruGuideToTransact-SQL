DECLARE @df nvarchar(64)
EXECUTE master.dbo.xp_regread N'HKEY_CURRENT_USER', N'Control Panel\International', N'sShortDate', @df OUT, N'no_output'
SELECT @df
