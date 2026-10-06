USE dunnhumby_rfm;

SELECT COUNT(*)                      AS item_rows,
       COUNT(DISTINCT basket_id)     AS baskets,
       COUNT(DISTINCT household_key) AS households
FROM transactions;

SELECT basket_id, COUNT(*) AS items, SUM(sales_value) AS basket_total
FROM transactions
GROUP BY basket_id
LIMIT 5;

SELECT * FROM transactions WHERE basket_id = 12345678901;

-- Rule: one row = one product. Frequency = COUNT(DISTINCT

SELECT SUM(sales_value > 0) AS positive_rows,
       SUM(sales_value = 0) AS zero_rows,
       SUM(sales_value < 0) AS negative_rows
FROM transactions;

-- Decision: only rows with sales_value > 0 count as sales.

SELECT MIN(day_num) AS first_day,
       MAX(day_num) AS last_day,
       MAX(week_no) AS weeks_covered
FROM transactions;

-- Reference day = MAX(day_num) + 1  (= 712).
-- recency_days = reference day - household's last shopping day.

SELECT (SELECT COUNT(DISTINCT household_key) FROM transactions)  AS all_households,
       (SELECT COUNT(*) FROM hh_demographic)                      AS with_demographics,
       (SELECT COUNT(DISTINCT household_key) FROM campaign_table) AS got_a_campaign;
       
SELECT COUNT(DISTINCT t.household_key) AS households
FROM transactions t
JOIN hh_demographic d ON d.household_key = t.household_key;
-- INNER JOIN: only households that exist in both tables

SELECT COUNT(DISTINCT t.household_key) AS households
FROM transactions t
LEFT JOIN hh_demographic d ON d.household_key = t.household_key
-- LEFT JOIN: every household AND demographics where available

-- Rule: demographics cover 801 of 2,500 households.
-- LEFT JOIN used beacuse every household must stay. demographic findings are indicative.