view: date_dim_next_year_date_dim_next_year_weekly_sales_weekly_web_catalog_sales_facts_fields {
  dimension: pk {
    primary_key: yes
    hidden: no
    label: "Date Pair Key"
    description: "Composite day-pair grain key across current-year and next-year date_dim rows."
    type: string
    sql: CONCAT(CAST(COALESCE(${date_dim.d_date_sk}, -1) AS STRING), '_', CAST(COALESCE(${next_year_date_dim.d_date_sk}, -1) AS STRING)) ;;
  }

  dimension: sun_sales_yoy_ratio {
    type: number
    label: "Sunday Sales YoY Ratio"
    description: "Ratio of weekly Sunday sales to next-year (+53 weeks) weekly Sunday sales, rounded to 2 decimal places."
    tags: ["non_additive"]
    value_format_name: decimal_2
    sql: ROUND(${weekly_web_catalog_sales_facts.sun_sales} / NULLIF(${next_year_weekly_sales.sun_sales}, 0), 2) ;;
  }

  dimension: mon_sales_yoy_ratio {
    type: number
    label: "Monday Sales YoY Ratio"
    description: "Ratio of weekly Monday sales to next-year (+53 weeks) weekly Monday sales, rounded to 2 decimal places."
    tags: ["non_additive"]
    value_format_name: decimal_2
    sql: ROUND(${weekly_web_catalog_sales_facts.mon_sales} / NULLIF(${next_year_weekly_sales.mon_sales}, 0), 2) ;;
  }

  dimension: tue_sales_yoy_ratio {
    type: number
    label: "Tuesday Sales YoY Ratio"
    description: "Ratio of weekly Tuesday sales to next-year (+53 weeks) weekly Tuesday sales, rounded to 2 decimal places."
    tags: ["non_additive"]
    value_format_name: decimal_2
    sql: ROUND(${weekly_web_catalog_sales_facts.tue_sales} / NULLIF(${next_year_weekly_sales.tue_sales}, 0), 2) ;;
  }

  dimension: wed_sales_yoy_ratio {
    type: number
    label: "Wednesday Sales YoY Ratio"
    description: "Ratio of weekly Wednesday sales to next-year (+53 weeks) weekly Wednesday sales, rounded to 2 decimal places."
    tags: ["non_additive"]
    value_format_name: decimal_2
    sql: ROUND(${weekly_web_catalog_sales_facts.wed_sales} / NULLIF(${next_year_weekly_sales.wed_sales}, 0), 2) ;;
  }

  dimension: thu_sales_yoy_ratio {
    type: number
    label: "Thursday Sales YoY Ratio"
    description: "Ratio of weekly Thursday sales to next-year (+53 weeks) weekly Thursday sales, rounded to 2 decimal places."
    tags: ["non_additive"]
    value_format_name: decimal_2
    sql: ROUND(${weekly_web_catalog_sales_facts.thu_sales} / NULLIF(${next_year_weekly_sales.thu_sales}, 0), 2) ;;
  }

  dimension: fri_sales_yoy_ratio {
    type: number
    label: "Friday Sales YoY Ratio"
    description: "Ratio of weekly Friday sales to next-year (+53 weeks) weekly Friday sales, rounded to 2 decimal places."
    tags: ["non_additive"]
    value_format_name: decimal_2
    sql: ROUND(${weekly_web_catalog_sales_facts.fri_sales} / NULLIF(${next_year_weekly_sales.fri_sales}, 0), 2) ;;
  }

  dimension: sat_sales_yoy_ratio {
    type: number
    label: "Saturday Sales YoY Ratio"
    description: "Ratio of weekly Saturday sales to next-year (+53 weeks) weekly Saturday sales, rounded to 2 decimal places."
    tags: ["non_additive"]
    value_format_name: decimal_2
    sql: ROUND(${weekly_web_catalog_sales_facts.sat_sales} / NULLIF(${next_year_weekly_sales.sat_sales}, 0), 2) ;;
  }
}
