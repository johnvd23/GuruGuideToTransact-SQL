DROP INDEX financial_median.k1
ALTER TABLE financial_median DROP COLUMN k1
CREATE CLUSTERED INDEX c1 ON financial_median (c1)
ALTER TABLE financial_median ADD k1 int identity 
DROP INDEX financial_median.c1
CREATE CLUSTERED INDEX k1 ON financial_median (k1) 
