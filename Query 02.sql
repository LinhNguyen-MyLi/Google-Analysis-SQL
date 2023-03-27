-- Query 02: Bounce rate per traffic source in July 2017
#standardSQL

WITH calculated AS
(
  SELECT trafficSource.source AS source,
         COUNT( trafficSource.source ) AS total_visits,
         SUM ( totals.bounces ) AS total_no_of_bounces
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
     _TABLE_SUFFIX BETWEEN '20170701' AND '20170731'
GROUP BY trafficSource.source
)

SELECT cal.source,
       cal.total_visits,
       cal.total_no_of_bounces,
       (( total_no_of_bounces / total_visits ) * 100 ) AS bounce_rate
FROM calculated AS cal
ORDER BY cal.total_visits DESC;
