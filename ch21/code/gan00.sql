SET ANSI_NULL_DFLT_OFF ON
GO
DECLARE @ansinull int

SET @ansinull=GETANSINULL('tempdb')  -- Save it off so that we can restore it later

IF (@ansinull=0)
  SET ANSI_NULL_DFLT_ON ON

CREATE TABLE #nulltest (c1 int)

INSERT #nulltest (c1) VALUES (NULL)

SELECT * FROM #nulltest

IF (@ansinull=0)  -- Reverse the setting above
  SET ANSI_NULL_DFLT_ON OFF
GO
DROP TABLE #nulltest
GO
SET ANSI_NULL_DFLT_OFF OFF
GO