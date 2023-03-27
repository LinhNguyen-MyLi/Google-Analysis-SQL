-- Query 01: calculate total visit, pageview, transaction and revenue for Jan, Feb and March 2017 order by month
#standardSQL

SELECT
      FORMAT_DATE('%Y%m ',PARSE_DATE('%Y%m%d',date)) AS month,
      SUM(totals.visits) AS visits,
      SUM(totals.pageviews) AS pageviews,
      SUM(totals.transactions) AS transactions,
      SUM(totals.totalTransactionRevenue)/1000000 AS revenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE
     _TABLE_SUFFIX BETWEEN '01' AND '04'
GROUP BY month
ORDER BY month;