SELECT PWDENCRYPT('vengeance') AS EncryptedString,PWDCOMPARE('vengeance', PWDENCRYPT('vengeance'), 0) AS EncryptedCompare
