USE dunnhumby_rfm;

DROP TABLE IF EXISTS rfm_scores;

CREATE TABLE rfm_scores AS
SELECT household_key,
       recency_days,
       frequency,
       monetary,
       NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
       NTILE(5) OVER (ORDER BY frequency ASC)     AS f_score,
       NTILE(5) OVER (ORDER BY monetary ASC)      AS m_score
FROM rfm_base;

SELECT r_score, COUNT(*) AS households,
       MIN(recency_days) AS min_days, MAX(recency_days) AS max_days
FROM rfm_scores
GROUP BY r_score
ORDER BY r_score;
-- Each score should hold 500 households. The day ranges should get smaller as the score goes up, because score 5 means most recent.

SELECT f_score, COUNT(*) AS households,
       MIN(frequency) AS min_trips, MAX(frequency) AS max_trips
FROM rfm_scores GROUP BY f_score ORDER BY f_score;

SELECT m_score, COUNT(*) AS households,
       MIN(monetary) AS min_spend, MAX(monetary) AS max_spend
FROM rfm_scores GROUP BY m_score ORDER BY m_score;
-- Score 5 should hold the most trips and the highest spend. You'll usually see that F and M rise together, because frequent shoppers spend more. Note the minimum spend in M band 5; it's your "top 20% spender" cut-off.

-- 5.3 Assign named segments
DROP TABLE IF EXISTS rfm_segments;

CREATE TABLE rfm_segments AS
SELECT *,
  CASE
    WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
    WHEN f_score >= 4 AND r_score >= 3                  THEN 'Loyal'
    WHEN r_score <= 2 AND m_score >= 3                  THEN 'At Risk'
    WHEN r_score >= 4 AND f_score >= 2                  THEN 'Potential Loyalists'
    WHEN r_score >= 4                                   THEN 'Occasional'
    WHEN r_score = 3                                    THEN 'Needs Attention'
    ELSE 'Hibernating'
  END AS segment
FROM rfm_scores;

SELECT segment, COUNT(*) AS households
FROM rfm_segments
GROUP BY segment
ORDER BY households DESC;