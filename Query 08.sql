--Query 08: Calculate cohort map from pageview to addtocart to purchase in last 3 month. For example, 100% pageview then 40% add_to_cart and 10% purchase.
#standardSQL

SELECT
  FORMAT_DATE('%Y%m ',PARSE_DATE('%Y%m%d',date)) AS month,
  COUNT(CASE WHEN hits.eCommerceAction.action_type = "2" THEN 1 END) AS num_product_view,
  COUNT(CASE WHEN hits.eCommerceAction.action_type = "3" THEN 1 END) AS num_addtocart,
  COUNT(CASE WHEN hits.eCommerceAction.action_type = "6" THEN 1 END) AS num_purchase,

  ROUND((CASE WHEN COUNT(CASE WHEN hits.ecommerceaction.action_type = '2' THEN fullvisitorid ELSE NULL END) = 0 THEN 0 
            ELSE COUNT(CASE WHEN hits.ecommerceaction.action_type = '3' THEN fullvisitorid ELSE NULL END) 
            / COUNT(CASE WHEN hits.ecommerceaction.action_type = '2' then fullvisitorid ELSE NULL END) END)*100,2) AS cart_to_detail_rate,

  ROUND((CASE WHEN COUNT(CASE WHEN hits.ecommerceaction.action_type = '2' THEN fullvisitorid ELSE NULL END) = 0 THEN 0 
            ELSE COUNT(CASE WHEN hits.ecommerceaction.action_type = '6' THEN hits.transaction.transactionid ELSE NULL END) 
            / COUNT(CASE WHEN hits.ecommerceaction.action_type = '2' then fullvisitorid ELSE NULL END) END)*100,2) AS buy_to_detail_rate

FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
  UNNEST (hits) AS hits,
  UNNEST (hits.product) AS product
WHERE
_TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
GROUP BY
  month
ORDER BY
  month;