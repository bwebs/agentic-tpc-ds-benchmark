include: "/gold/store_monthly_sales_lag_lead.view.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"

explore: store_monthly_sales_lag_lead {
  view_name: store_monthly_sales_lag_lead
  label: "Store Monthly Sales Lag & Lead"
  tags: ["gold"]

  always_filter: {
    filters: [
      store_monthly_sales_lag_lead.target_year: "1999"
    ]
  }

  join: _sdt_ss {
    from: store_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_i {
    from: item
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

  query: monthly_sales_deviation_lag_lead_1999 {
    description: "1999 monthly store sales by item category exceeding 10% deviation from the annual monthly average, with prior and next ranked month sales"
    dimensions: [
      store_monthly_sales_lag_lead.i_category,
      store_monthly_sales_lag_lead.d_year,
      store_monthly_sales_lag_lead.d_moy,
      store_monthly_sales_lag_lead.avg_monthly_sales,
      store_monthly_sales_lag_lead.sum_sales,
      store_monthly_sales_lag_lead.psum,
      store_monthly_sales_lag_lead.nsum,
      store_monthly_sales_lag_lead.sales_vs_avg_diff
    ]
    filters: [
      store_monthly_sales_lag_lead.target_year: "1999",
      store_monthly_sales_lag_lead.d_year: "1999",
      store_monthly_sales_lag_lead.is_above_10pct_deviation: "Yes"
    ]
    sorts: [
      store_monthly_sales_lag_lead.sales_vs_avg_diff: asc,
      store_monthly_sales_lag_lead.d_moy: asc
    ]
    limit: 100
  }
}
