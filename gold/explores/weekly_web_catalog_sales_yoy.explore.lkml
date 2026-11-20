include: "/gold/date_week_offset_spine.view.lkml"
include: "/silver/weekly_web_catalog_sales_facts.view.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"

explore: weekly_web_catalog_sales_yoy {
  view_name: date_week_offset_spine
  label: "Weekly Web and Catalog Sales YoY"
  tags: ["gold"]
  cancel_grouping_fields: [date_week_offset_spine.d_week_seq]

  join: weekly_web_catalog_sales_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${date_week_offset_spine.d_week_seq} = ${weekly_web_catalog_sales_facts.d_week_seq} ;;
  }

  join: next_year_weekly_sales {
    from: weekly_web_catalog_sales_facts
    type: left_outer
    relationship: many_to_one
    sql_on: ${date_week_offset_spine.next_year_d_week_seq} = ${next_year_weekly_sales.d_week_seq} ;;
  }

  join: _sdt_curr_date {
    from: date_dim
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_next_date {
    from: date_dim
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_web_sales {
    from: web_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_catalog_sales {
    from: catalog_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: weekly_yoy_day_of_week_sales {
    description: "Weekly web and catalog day-of-week sales paired with 53-week-ahead next-year weekly sales"
    dimensions: [date_week_offset_spine.d_week_seq, weekly_web_catalog_sales_facts.sun_sales, weekly_web_catalog_sales_facts.mon_sales, weekly_web_catalog_sales_facts.tue_sales, weekly_web_catalog_sales_facts.wed_sales, weekly_web_catalog_sales_facts.thu_sales, weekly_web_catalog_sales_facts.fri_sales, weekly_web_catalog_sales_facts.sat_sales, next_year_weekly_sales.sun_sales, next_year_weekly_sales.mon_sales, next_year_weekly_sales.tue_sales, next_year_weekly_sales.wed_sales, next_year_weekly_sales.thu_sales, next_year_weekly_sales.fri_sales, next_year_weekly_sales.sat_sales]
    filters: [
      date_week_offset_spine.d_year_num: "1998",
      date_week_offset_spine.next_year_d_year_num: "1999",
      weekly_web_catalog_sales_facts.d_week_seq: "NOT NULL",
      next_year_weekly_sales.d_week_seq: "NOT NULL"
    ]
    sorts: [date_week_offset_spine.d_week_seq: asc]
    limit: 5000
  }
}
