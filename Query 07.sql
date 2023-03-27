-- Query 07: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.
#standardSQL

WITH purchase_list AS
(
SELECT DISTINCT fullVisitorId,
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
       UNNEST(hits) AS hits,
       UNNEST(hits.product) AS product
WHERE product.v2ProductName = "YouTube Men's Vintage Henley"       
AND hits.eCommerceAction.action_type = '6'
)

SELECT product.v2ProductName AS other_purchased_products,
       SUM (product.productQuantity) AS quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
       UNNEST(hits) AS hits,
       UNNEST(hits.product) AS product
JOIN purchase_list USING (fullVisitorId)
WHERE product.v2ProductName != "YouTube Men's Vintage Henley"
AND product.productRevenue IS NOT NULL
GROUP BY other_purchased_products
ORDER BY quantity DESC;