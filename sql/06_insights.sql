USE dunnhumby_rfm;

SELECT segment,
       COUNT(*)                                                   AS households,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)           AS pct_households,
       ROUND(SUM(monetary), 0)                                    AS sales_usd,
       ROUND(100 * SUM(monetary) / SUM(SUM(monetary)) OVER (), 1) AS pct_sales,
       ROUND(AVG(frequency))                                      AS avg_trips,
       ROUND(AVG(monetary), 2)                                    AS avg_spend,
       ROUND(AVG(recency_days))                                   AS avg_days_since_trip
FROM rfm_segments
GROUP BY segment
ORDER BY sales_usd DESC;

SELECT ROUND(100 * SUM(CASE WHEN decile = 1 THEN monetary ELSE 0 END)
                 / SUM(monetary), 1) AS top10_pct_of_sales
FROM (
  SELECT monetary,
         NTILE(10) OVER (ORDER BY monetary DESC) AS decile
  FROM rfm_segments
) AS d;

SELECT decile,
       ROUND(SUM(monetary), 0) AS sales_usd,
       ROUND(100 * SUM(monetary) / SUM(SUM(monetary)) OVER (), 1) AS pct_sales
FROM (
  SELECT monetary, NTILE(10) OVER (ORDER BY monetary DESC) AS decile
  FROM rfm_segments
) AS d
GROUP BY decile
ORDER BY decile;

SELECT COUNT(*)                 AS at_risk_households,
       ROUND(SUM(monetary), 0)  AS past_sales_usd,
       ROUND(AVG(monetary), 2)  AS avg_spend,
       ROUND(AVG(recency_days)) AS avg_days_inactive
FROM rfm_segments
WHERE segment = 'At Risk';

SELECT s.segment,
       COUNT(*)                                         AS households,
       SUM(c.household_key IS NOT NULL)                 AS got_a_campaign,
       ROUND(100 * AVG(c.household_key IS NOT NULL), 1) AS pct_reached
FROM rfm_segments s
LEFT JOIN (
  SELECT DISTINCT household_key FROM campaign_table
) AS c ON c.household_key = s.household_key
GROUP BY s.segment
ORDER BY pct_reached;

SELECT s.segment,
       COUNT(*)               AS households,
       COUNT(d.household_key) AS with_demographics
FROM rfm_segments s
LEFT JOIN hh_demographic d ON d.household_key = s.household_key
GROUP BY s.segment;

SELECT s.segment, d.income_desc, COUNT(*) AS households
FROM rfm_segments s
JOIN hh_demographic d ON d.household_key = s.household_key
WHERE s.segment IN ('Champions', 'At Risk')
GROUP BY s.segment, d.income_desc
ORDER BY s.segment, households DESC