SET GLOBAL local_infile = 1;

USE dunnhumby_rfm;

LOAD DATA LOCAL INFILE 'C:/Users/arora/OneDrive/Desktop/rfm-customer-segmentation/data/transaction_data.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/arora/OneDrive/Desktop/rfm-customer-segmentation/data/hh_demographic.csv'
INTO TABLE hh_demographic
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/arora/OneDrive/Desktop/rfm-customer-segmentation/data/campaign_table.csv'
INTO TABLE campaign_table
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT 'transactions' AS table_name, COUNT(*) AS row_count FROM transactions
UNION ALL
SELECT 'hh_demographic', COUNT(*) FROM hh_demographic
UNION ALL
SELECT 'campaign_table', COUNT(*) FROM campaign_table;

SELECT * FROM transactions LIMIT 10;
SELECT * FROM hh_demographic LIMIT 10;
SELECT * FROM campaign_table LIMIT 10;
-- checking every row arrived