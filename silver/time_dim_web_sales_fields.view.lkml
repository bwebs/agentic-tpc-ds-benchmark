include: "/bronze/time_dim.view.lkml"
include: "/bronze/time_dim.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"

view: time_dim_web_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${web_sales.pk} ;;
  }

  measure: hour_12_13_sales_count {
    label: "Hour 12-13 Web Sales Count"
    description: "Count of web sales line items sold during hours 12 to 13 (COUNT(*) WHERE time_dim.t_hour BETWEEN 12 AND 13)."
    type: count
    filters: [time_dim.t_hour: "[12, 13]"]
    synonyms: ["amc"]
  }

  measure: hour_20_21_sales_count {
    label: "Hour 20-21 Web Sales Count"
    description: "Count of web sales line items sold during hours 20 to 21 (COUNT(*) WHERE time_dim.t_hour BETWEEN 20 AND 21)."
    type: count
    filters: [time_dim.t_hour: "[20, 21]"]
    synonyms: ["pmc"]
  }

  measure: am_pm_sales_ratio {
    label: "AM to PM Web Sales Ratio"
    description: "Ratio of web sales count in hours 12-13 to web sales count in hours 20-21 (amc / NULLIF(pmc, 0))."
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${hour_12_13_sales_count} / NULLIF(${hour_20_21_sales_count}, 0) ;;
    value_format_name: decimal_4
    synonyms: ["am_pm_ratio"]
  }
}
