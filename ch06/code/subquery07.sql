SET NOCOUNT ON
CREATE TABLE #nameservers (domain varchar(30), ns1 varchar(15), ns2 varchar(15))

INSERT #nameservers VALUES ('foolsrus.com','24.99.0.9','24.99.0.8')
INSERT #nameservers VALUES ('wewanturbuks.gov','127.0.0.2','127.0.0.3')
INSERT #nameservers VALUES ('sayhitomom.edu','127.0.0.4','24.99.0.8')
INSERT #nameservers VALUES ('knickstink.org','192.168.0.254','192.168.0.255')
INSERT #nameservers VALUES ('nukemnut.com','24.99.0.6','24.99.0.7')
INSERT #nameservers VALUES ('wedigdiablo.org','24.99.0.9','24.99.0.8')
INSERT #nameservers VALUES ('gospamurself.edu','192.168.0.255','192.168.0.254')
INSERT #nameservers VALUES ('ou812.com','100.10.0.100','100.10.0.101')
INSERT #nameservers VALUES ('rothrulz.org','100.10.0.102','24.99.0.8')


SELECT n.domain, n.ns1, n.ns2
FROM #nameservers n JOIN #nameservers a ON 
   (n.domain<>a.domain AND ((n.ns1=a.ns1 AND n.ns2=a.ns2) OR (n.ns1=a.ns2 AND n.ns2=a.ns1)))
ORDER BY 2,3,1
GO
DROP TABLE #nameservers