USE pubs
SELECT 	
PayTerms=isnull(s.payterms,'NA'),
"Less than 10"=COUNT(CASE WHEN s.sales >=0 AND s.sales <10 THEN 1 ELSE NULL END),
"10-19"=COUNT(CASE WHEN s.sales >=10 AND s.sales <20 THEN 1 ELSE NULL END), 
"20-29"=COUNT(CASE WHEN s.sales >=20 AND s.sales <30 THEN 1 ELSE NULL END), 
"30-39"=COUNT(CASE WHEN s.sales >=30 AND s.sales <40 THEN 1 ELSE NULL END),
"40-49"=COUNT(CASE WHEN s.sales >=40 AND s.sales <50 THEN 1 ELSE NULL END),
"50 or more"=COUNT(CASE WHEN s.sales >=50 THEN 1 ELSE NULL END)
FROM (SELECT t.title_id, s.payterms, sales=ISNULL(SUM(s.qty),0) FROM titles t LEFT OUTER JOIN sales s ON (t.title_id=s.title_id) GROUP BY t.title_id, payterms) s
GROUP BY s.payterms
