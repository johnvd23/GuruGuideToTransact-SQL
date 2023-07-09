DECLARE @s1 varchar(20),@s2 varchar(20),@s3 varchar(20),@s4 varchar(20),
  @s5 varchar(20),@s6 varchar(20),@s7 varchar(20),@s8 varchar(20),
  @s9 varchar(20),@s10 varchar(20),@s11 varchar(20),@s12 varchar(20)
EXEC master..xp_sscanf 
'He Medi tated for a Moment, Then Kneeling Over and Across the Ogre , King Arthur Looked Up 
and Proclaimed His Wish : Now, Miserable Beasts That Hack The Secret of the Ancient Code 
And Run the Gauntlet, Today I Bid You Farewell', 'He %s tated for a Moment, Then Kneeling %cver and A%cross the Og%s , King Arthur Looked %cp and Proclaimed His %s : Now, %s Beasts That %s The Secret %s the %cncient %s And %cun the Gauntlet, Today I Bid Your Farewell', @s1 OUT, @s2 OUT, 
@s3 OUT, @s4 OUT, @s5 OUT, @s6 OUT, @s7 OUT, @s8 OUT, @s9 OUT, @s10 OUT, @s11 OUT, @s12 OUT

SELECT @s1+@s2+@s3+@s4+'? '+@s5+' '+@s6+', '+@s5+' '+@s7+' '+@s8+' '+@s9+
' '+@s10+' '+@s11+@s12
