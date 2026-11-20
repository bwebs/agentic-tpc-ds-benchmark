include: "/silver/all_channel_sales.view.lkml"
include: "/silver/all_channel_sales_customer_date_dim_fields.view.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"

explore: all_channel_sales {
  hidden: no
  label: "All Channel Sales"
  view_name: all_channel_sales

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${all_channel_sales.customer_sk} = ${customer.c_customer_sk} ;;
  }

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${all_channel_sales.sold_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: all_channel_sales_customer_date_dim_fields {
    sql: ;;
    relationship: one_to_one
  }

  join: _sdt_store_sales {
    from: store_sales
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

  join: _sdt_web_sales {
    from: web_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }
}
