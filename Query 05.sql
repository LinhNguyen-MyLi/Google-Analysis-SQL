-- Query 05: Average number of transactions per user that made a purchase in July 2017
#standardSQL

SELECT
  FORMAT_DATE('%Y%m ',PARSE_DATE('%Y%m%d',date)) AS month,
  (SUM (total_transactions_per_user) / COUNT(DISTINCT user_id) ) AS Avg_total_transactions_per_user
FROM (
  SELECT
    date,
    fullVisitorId AS user_id,
    SUM (totals.transactions) AS total_transactions_per_user
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20170701'AND '20170731'
    AND totals.transactions >=1
  GROUP BY user_id,date)
GROUP BY
  month;