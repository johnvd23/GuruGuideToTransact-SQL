@ECHO OFF
isql -Usa -P -iraiserror01.sql
ECHO %ERRORLEVEL%

osql -Usa -P -iraiserror01.sql
ECHO %ERRORLEVEL%