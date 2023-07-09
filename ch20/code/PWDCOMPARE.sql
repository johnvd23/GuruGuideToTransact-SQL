SELECT PWDCOMPARE('enmity', password, (CASE WHEN xstatus&2048=2048 THEN 1 ELSE 0 END))
FROM sysxlogins 
WHERE name='k_reapr'
