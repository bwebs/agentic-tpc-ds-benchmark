include: "/gold/county_quarterly_sales_growth.view.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"

explore: county_quarterly_sales_growth {
  view_name: county_quarterly_sales_growth
  label: "County Quarterly Sales Growth"
  tags: ["gold"]

  join: _sdt_ss {
    from: store_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_ws {
    from: web_sales
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

  join: _sdt_ca {
    from: customer_address
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: counties_web_outgrowing_store_2001_q1_q3 {
    description: "Counties in 2001 where web sales Q1->Q2 and Q2->Q3 growth ratios both exceed store sales growth ratios"
    dimensions: [
      county_quarterly_sales_growth.ca_county,
      county_quarterly_sales_growth.d_year
    ]
    measures: [
      county_quarterly_sales_growth.web_q1_q2_increase,
      county_quarterly_sales_growth.store_q1_q2_increase,
      county_quarterly_sales_growth.web_q2_q3_increase,
      county_quarterly_sales_growth.store_q2_q3_increase
    ]
    filters: [
      county_quarterly_sales_growth.d_year: "2001",
      county_quarterly_sales_growth.is_web_outgrowing_store_q1_to_q3: "Yes"
    ]
    sorts: [county_quarterly_sales_growth.d_year: asc]
    limit: 500
  }
}
