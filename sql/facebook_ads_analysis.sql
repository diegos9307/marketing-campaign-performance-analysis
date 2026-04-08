-- This query cleans Facebook Ads data by standardising gender and grouping ages.
-- It also calculates key performance metrics such as CTR, conversion rate and CPA,
-- and creates an efficiency flag based on cost per acquisition.

SELECT
  ad_id,
  campaign_id,

  -- Clean gender values
  CASE
    WHEN gender = "m" THEN "Male"
    WHEN gender = "f" THEN "Female"
    ELSE "Other"
  END AS gender_clean,

  -- Group age into ranges (handles both numeric and range formats)
  CASE
    WHEN SAFE_CAST(age AS INT64) BETWEEN 18 AND 29 THEN "18-29"
    WHEN SAFE_CAST(age AS INT64) BETWEEN 30 AND 44 THEN "30-44"
    WHEN SAFE_CAST(age AS INT64) BETWEEN 45 AND 59 THEN "45-59"
    WHEN SAFE_CAST(age AS INT64) BETWEEN 60 AND 70 THEN "60-70"

    WHEN REGEXP_CONTAINS(age, r'\d+-\d+') THEN
      CASE
        WHEN CAST(REGEXP_EXTRACT(age, r'\d+') AS INT64) BETWEEN 18 AND 29 THEN "18-29"
        WHEN CAST(REGEXP_EXTRACT(age, r'\d+') AS INT64) BETWEEN 30 AND 44 THEN "30-44"
        WHEN CAST(REGEXP_EXTRACT(age, r'\d+') AS INT64) BETWEEN 45 AND 59 THEN "45-59"
        WHEN CAST(REGEXP_EXTRACT(age, r'\d+') AS INT64) BETWEEN 60 AND 70 THEN "60-70"
      END
  END AS age_group,

  impressions,
  clicks,
  spent,
  conversion AS conversions,

  -- Performance metrics
  SAFE_DIVIDE(clicks, impressions) AS ctr,
  SAFE_DIVIDE(approved_conversion, clicks) AS conversion_rate,
  SAFE_DIVIDE(spent, conversion) AS cpa,

  -- Efficiency classification based on CPA
  CASE
    WHEN conversion = 0 THEN "No Conversions"
    WHEN SAFE_DIVIDE(spent, approved_conversion) < 20 THEN "Efficient"
    ELSE "Inefficient"
  END AS efficiency_flag

FROM `marketing_data.facebook_ads_clean`
