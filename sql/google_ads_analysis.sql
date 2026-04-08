-- This query aggregates Google Ads data by campaign, keyword, device and location.
-- It calculates key marketing metrics such as CTR, conversion rate, CPA and ROAS,
-- and classifies campaign performance based on ROAS.

SELECT
  campaign_name,
  keyword,
  device,
  location,

  -- Aggregated metrics
  SUM(impressions) AS impressions,
  SUM(clicks) AS clicks,
  SUM(cost) AS cost,
  SUM(conversions) AS conversions,
  SUM(revenue) AS revenue,

  -- Performance metrics
  SAFE_DIVIDE(SUM(clicks), SUM(impressions)) AS ctr,
  SAFE_DIVIDE(SUM(conversions), SUM(clicks)) AS conversion_rate,
  SAFE_DIVIDE(SUM(cost), SUM(conversions)) AS cpa,
  SAFE_DIVIDE(SUM(revenue), SUM(cost)) AS roas,

  -- Performance classification
  CASE
    WHEN SAFE_DIVIDE(SUM(sale_amount), SUM(cost)) >= 6.5 THEN "High Performer"
    WHEN SAFE_DIVIDE(SUM(sale_amount), SUM(cost)) >= 4 THEN "Average"
    ELSE "Underperforming"
  END AS performance_category

FROM `marketing_data.google_ads_clean`

GROUP BY
  campaign_name,
  keyword,
  device,
  location
