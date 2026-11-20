include: "/silver/explores/weekly_web_catalog_sales_facts.explore.lkml"
include: "/gold/date_dim_next_year_date_dim_next_year_weekly_sales_weekly_web_catalog_sales_facts_fields.view.lkml"

explore: weekly_web_catalog_sales_yoy {
  extends: [weekly_web_catalog_sales_facts]
  hidden: no
  label: "Weekly Web & Catalog Sales YoY"
  view_name: weekly_web_catalog_sales_facts
  tags: ["gold"]

  join: next_year_weekly_sales {
    from: weekly_web_catalog_sales_facts
    view_label: "Next Year Weekly Sales (+53w)"
    type: left_outer
    relationship: one_to_one
    sql_on: ${weekly_web_catalog_sales_facts.d_week_seq} = ${next_year_weekly_sales.d_week_seq} - 53 ;;
  }

  join: next_year_date_dim {
    from: date_dim
    view_label: "Next Year Date"
    type: left_outer
    relationship: many_to_many
    sql_on: ${next_year_date_dim.d_week_seq} = ${next_year_weekly_sales.d_week_seq} ;;
  }

  join: date_dim_next_year_date_dim_next_year_weekly_sales_weekly_web_catalog_sales_facts_fields {
    view_label: "Weekly YoY Ratios"
    sql: ;;
    relationship: one_to_one
  }

  query: weekly_sales_yoy_1998_vs_1999 {
    description: "Year-over-year day-of-week web and catalog sales ratios comparing 1998 weeks against 1999 (+53 weeks)"
    dimensions: [
      weekly_web_catalog_sales_facts.d_week_seq,
      date_dim_next_year_date_dim_next_year_weekly_sales_weekly_web_catalog_sales_facts_fields.sun_sales_yoy_ratio,
      date_dim_next_year_date_dim_next_year_weekly_sales_weekly_web_catalog_sales_facts_fields.mon_sales_yoy_ratio,
      date_dim_next_year_date_dim_next_year_weekly_sales_weekly_web_catalog_sales_facts_fields.tue_sales_yoy_ratio,
      date_dim_next_year_date_dim_next_year_weekly_sales_weekly_web_catalog_sales_facts_fields.wed_sales_yoy_ratio,
      date_dim_next_year_date_dim_next_year_weekly_sales_weekly_web_catalog_sales_facts_fields.thu_sales_yoy_ratio,
      date_dim_next_year_date_dim_next_year_weekly_sales_weekly_web_catalog_sales_facts_fields.fri_sales_yoy_ratio,
      date_dim_next_year_date_dim_next_year_weekly_sales_weekly_web_catalog_sales_facts_fields.sat_sales_yoy_ratio
    ]
    filters: [
      date_dim.d_year_num: "1998",
      next_year_date_dim.d_year_num: "1999"
    ]
    sorts: [weekly_web_catalog_sales_facts.d_week_seq: asc]
    limit: 5000
  }
}
