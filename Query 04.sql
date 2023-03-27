--Query 04: Average number of product pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017. Note: totals.transactions >=1 for purchaser and totals.transactions is null for non-purchaser
#standardSQL

WITH purchase AS (
SELECT
    FORMAT_DATE('%Y%m ',PARSE_DATE('%Y%m%d',date)) AS month,
    ( SUM(total_pagesviews_purchase) / COUNT(DISTINCT user_id) ) AS avg_pageviews_purchase
FROM (
    SELECT
      date,
      fullVisitorId AS user_id,
      SUM(totals.pageviews) AS total_pagesviews_purchase
    FROM
      `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    WHERE
      _TABLE_SUFFIX BETWEEN '20170601'AND '20170731'
      AND totals.transactions >=1
    GROUP BY
      date,user_id )
GROUP BY
      month ),

no_purchase AS (
SELECT
      FORMAT_DATE('%Y%m ',PARSE_DATE('%Y%m%d',date)) AS month,
      ( SUM(total_pagesviews_non_purchase) / COUNT(DISTINCT user_id) ) AS avg_pageviews_non_purchase
FROM (
      SELECT
        date,
        fullVisitorId AS user_id,
        SUM(totals.pageviews) AS total_pagesviews_non_purchase
      FROM
        `bigquery-public-data.google_analytics_sample.ga_sessions_*`
      WHERE
        _TABLE_SUFFIX BETWEEN '20170601'AND '20170731'
        AND totals.transactions IS NULL
      GROUP BY
        user_id,date )
GROUP BY
      month )

SELECT
      purchase.month,
      purchase.avg_pageviews_purchase,
      no_purchase.avg_pageviews_non_purchase
FROM purchase,no_purchase
WHERE purchase.month = no_purchase.month
ORDER BY purchase.month ;