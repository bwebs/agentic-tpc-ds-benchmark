include: "/gold/cross_channel_store_sales_yoy.view.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/catalog_returns.view.lkml"
include: "/bronze/catalog_returns.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_demographics.view.lkml"
include: "/bronze/customer_demographics.refinement.lkml"
include: "/bronze/promotion.view.lkml"
include: "/bronze/promotion.refinement.lkml"
include: "/bronze/household_demographics.view.lkml"
include: "/bronze/household_demographics.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/income_band.view.lkml"
include: "/bronze/income_band.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"

explore: cross_channel_store_sales_yoy {
  view_name: cross_channel_store_sales_yoy
  label: "Cross-Channel Store Sales YoY"
  description: "Year-over-year returned store sales comparison for items with >2x catalog sales-to-refund ratio and marital status changes between sale and current customer demographics."
  tags: ["gold"]

  join: _sdt_cs {
    from: catalog_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_cr {
    from: catalog_returns
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_ss {
    from: store_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_sr {
    from: store_returns
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_d1 {
    from: date_dim
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_d2 {
    from: date_dim
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_d3 {
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

  join: _sdt_c {
    from: customer
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_cd1 {
    from: customer_demographics
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_cd2 {
    from: customer_demographics
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_p {
    from: promotion
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_hd1 {
    from: household_demographics
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_hd2 {
    from: household_demographics
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_ad1 {
    from: customer_address
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_ad2 {
    from: customer_address
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_ib1 {
    from: income_band
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_ib2 {
    from: income_band
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

  query: cross_channel_store_sales_yoy_2001 {
    description: "Year-over-year cross-channel returned store sales between 2001 and 2002 for qualifying catalog items ($59-$68, selected colors) where Year 2 count does not exceed Year 1 count"
    dimensions: [
      cross_channel_store_sales_yoy.product_name,
      cross_channel_store_sales_yoy.store_name,
      cross_channel_store_sales_yoy.store_zip,
      cross_channel_store_sales_yoy.b_street_number,
      cross_channel_store_sales_yoy.b_street_name,
      cross_channel_store_sales_yoy.b_city,
      cross_channel_store_sales_yoy.b_zip,
      cross_channel_store_sales_yoy.c_street_number,
      cross_channel_store_sales_yoy.c_street_name,
      cross_channel_store_sales_yoy.c_city,
      cross_channel_store_sales_yoy.c_zip,
      cross_channel_store_sales_yoy.syear,
      cross_channel_store_sales_yoy.cnt,
      cross_channel_store_sales_yoy.wholesale_cost_1,
      cross_channel_store_sales_yoy.list_price_1,
      cross_channel_store_sales_yoy.coupon_amt_1,
      cross_channel_store_sales_yoy.wholesale_cost_2,
      cross_channel_store_sales_yoy.list_price_2,
      cross_channel_store_sales_yoy.coupon_amt_2,
      cross_channel_store_sales_yoy.comparison_syear,
      cross_channel_store_sales_yoy.comparison_cnt,
      cross_channel_store_sales_yoy.pk
    ]
    filters: [
      cross_channel_store_sales_yoy.syear: "2001",
      cross_channel_store_sales_yoy.i_color: "cyan,peach,blush,frosted,powder,orange",
      cross_channel_store_sales_yoy.i_current_price: "[59, 68]"
    ]
    sorts: [
      cross_channel_store_sales_yoy.product_name: asc,
      cross_channel_store_sales_yoy.store_name: asc,
      cross_channel_store_sales_yoy.comparison_cnt: asc
    ]
  }
}
