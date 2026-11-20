include: "/gold/store_weekly_dow_sales_yoy.view.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"

explore: store_weekly_dow_sales_yoy {
  view_name: store_weekly_dow_sales_yoy
  label: "Store Weekly Day-of-Week Sales YoY"
  tags: ["gold"]

  always_filter: {
    filters: [
      store_weekly_dow_sales_yoy.start_month_seq: "1196"
    ]
  }

  join: _sdt_ss {
    from: store_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_d {
    from: date_dim
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_s {
    from: store
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: weekly_dow_sales_yoy_1196 {
    description: "Year-over-year day-of-week store sales ratios comparing 12-month window starting at month_seq 1196 against the following 12 months (+52 weeks)"
    dimensions: [
      store_weekly_dow_sales_yoy.s_store_name1,
      store_weekly_dow_sales_yoy.s_store_id1,
      store_weekly_dow_sales_yoy.d_week_seq1,
      store_weekly_dow_sales_yoy.sun_sales_ratio,
      store_weekly_dow_sales_yoy.mon_sales_ratio,
      store_weekly_dow_sales_yoy.tue_sales_ratio,
      store_weekly_dow_sales_yoy.wed_sales_ratio,
      store_weekly_dow_sales_yoy.thu_sales_ratio,
      store_weekly_dow_sales_yoy.fri_sales_ratio,
      store_weekly_dow_sales_yoy.sat_sales_ratio,
      store_weekly_dow_sales_yoy.pk
    ]
    filters: [
      store_weekly_dow_sales_yoy.start_month_seq: "1196"
    ]
    sorts: [
      store_weekly_dow_sales_yoy.s_store_name1: asc,
      store_weekly_dow_sales_yoy.s_store_id1: asc,
      store_weekly_dow_sales_yoy.d_week_seq1: asc
    ]
    limit: 100
  }
}
