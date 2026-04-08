-- This query aggregates marketing campaign data by campaign and category.
-- It calculates key performance metrics such as CTR, conversion rate, CPC, CPA and ROAS,
-- and classifies campaigns based on performance.

SELECT
  campaign_name,
  category,

  -- Aggregated metrics
  SUM(impressions) AS impressions,
  SUM(clicks) AS clicks,
  SUM(spend) AS spend,
  SUM(conversions) AS conversions,
  SUM(revenue) AS revenue,

  -- Performance metrics
  SAFE_DIVIDE(SUM(clicks), SUM(impressions)) AS ctr,
  SAFE_DIVIDE(SUM(conversions), SUM(clicks)) AS conversion_rate,
  SAFE_DIVIDE(SUM(spend), SUM(clicks)) AS cpc,
  SAFE_DIVIDE(SUM(spend), SUM(conversions)) AS cpa,
  SAFE_DIVIDE(SUM(revenue), SUM(spend)) AS roas,

  -- Performance classification (based on ROAS)
  CASE
    WHEN SAFE_DIVIDE(SUM(revenue), SUM(spend)) >= 3 THEN "High Performer"
    WHEN SAFE_DIVIDE(SUM(revenue), SUM(spend)) >= 1.5 THEN "Average"
    ELSE "Underperforming"
  END AS performance_category,

FROM `marketing_data.marketing_campaigns_clean`

GROUP BY
  campaign_name,
  category
