DROP TABLE IF EXISTS rfm_base;

CREATE TABLE rfm_base AS
SELECT b.household_key,
       (SELECT MAX(day_num) + 1 FROM transactions) - MAX(b.day_num) AS recency_days,
       COUNT(*)                                                    AS frequency,
       ROUND(SUM(b.basket_value), 2)                               AS monetary
FROM (
  SELECT household_key,
         basket_id,
         MIN(day_num)     AS day_num,
         SUM(sales_value) AS basket_value
  FROM transactions
  WHERE sales_value > 0
  GROUP BY household_key, basket_id
) AS b
GROUP BY b.household_key;

SELECT COUNT(*) AS households FROM rfm_base;-- 2500

SELECT MIN(recency_days), ROUND(AVG(recency_days)) AS avg_recency, MAX(recency_days),
       MIN(frequency), ROUND(AVG(frequency)) AS avg_trips, MAX(frequency),
       MIN(monetary), ROUND(AVG(monetary), 2) AS avg_spend, MAX(monetary)
FROM rfm_base;
-- Recency should never be negative. Frequency should range from a h

SELECT CASE WHEN recency_days <= 14 THEN '0-14 days'
            WHEN recency_days <= 30 THEN '15-30 days'
            WHEN recency_days <= 90 THEN '31-90 days'
            ELSE '90+ days' END                           AS last_trip,
       COUNT(*)                                           AS households,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)   AS pct
FROM rfm_base
GROUP BY last_trip
ORDER BY MIN(recency_days);
-- Most grocery shoppers come back every week or two, so a long gap is a warning sign. This buckets households by days since their last trip. Note how many are in the 31–90 and 90+ groups. They are your likely churners