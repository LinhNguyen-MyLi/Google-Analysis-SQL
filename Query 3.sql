-- Query 3: Revenue by traffic source by week, by month in June 2017

WITH week_month_2017 AS 
(
  SELECT
    "Week" AS time_type,
    FORMAT_DATE('%Y%W',PARSE_DATE('%Y%m%d',date)) AS time,
    trafficSource.source AS source,
    SUM(totals.totalTransactionRevenue)/1000000 AS revenue
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  WHERE
   _TABLE_SUFFIX BETWEEN '20170601' AND '20170631'
  GROUP BY
  1,2,3

UNION ALL

SELECT
    "Month" AS time_type,
    FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date)) AS time,
    trafficSource.source AS source,
    SUM(totals.totalTransactionRevenue)/1000000 AS revenue
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  WHERE
   _TABLE_SUFFIX BETWEEN '20170601' AND '20170631'
  GROUP BY
  1,2,3
)
SELECT
time_type,
time,
source,
revenue
FROM week_month_2017
ORDER BY revenue DESC  
