-- Query 06: Average amount of money spent per session
#standardSQL

SELECT
  FORMAT_DATE('%Y%m ',PARSE_DATE('%Y%m%d',date)) AS month,
  ( SUM(total_transactionrevenue_per_user) / COUNT(total_visits_per_user) ) AS Avg_revenue_by_user_per_visit
FROM (
  SELECT
    date,
    fullVisitorId,
    SUM( totals.visits ) AS total_visits_per_user,
    SUM( totals.transactionRevenue ) AS total_transactionrevenue_per_user
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20170701'
    AND '20170731'
    AND totals.visits > 0
    AND totals.transactions IS NOT NULL
  GROUP BY
    fullVisitorId,
    date )
GROUP BY
  month;