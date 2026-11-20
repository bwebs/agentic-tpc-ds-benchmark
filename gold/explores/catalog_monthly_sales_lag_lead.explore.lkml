include: "/gold/catalog_monthly_sales_lag_lead.view.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/call_center.view.lkml"
include: "/bronze/call_center.refinement.lkml"

explore: catalog_monthly_sales_lag_lead {
  view_name: catalog_monthly_sales_lag_lead
  label: "Catalog Monthly Sales Lag & Lead"
  tags: ["gold"]

  always_filter: {
    filters: [
      catalog_monthly_sales_lag_lead.target_year: "2000"
    ]
  }

  join: _sdt_cs {
    from: catalog_sales
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

  join: _sdt_cc {
    from: call_center
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: monthly_sales_deviation_lag_lead_2000 {
    description: "2000 monthly catalog sales by item brand exceeding 10% deviation from the annual monthly average, with prior and next ranked month sales"
    dimensions: [
      catalog_monthly_sales_lag_lead.i_brand,
      catalog_monthly_sales_lag_lead.d_year,
      catalog_monthly_sales_lag_lead.avg_monthly_sales,
      catalog_monthly_sales_lag_lead.sum_sales,
      catalog_monthly_sales_lag_lead.psum,
      catalog_monthly_sales_lag_lead.nsum,
      catalog_monthly_sales_lag_lead.sales_vs_avg_diff
    ]
    filters: [
      catalog_monthly_sales_lag_lead.target_year: "2000",
      catalog_monthly_sales_lag_lead.d_year: "2000",
      catalog_monthly_sales_lag_lead.is_above_10pct_deviation: "Yes"
    ]
    sorts: [
      catalog_monthly_sales_lag_lead.sales_vs_avg_diff: asc,
      catalog_monthly_sales_lag_lead.avg_monthly_sales: asc
    ]
    limit: 100
  }
}
