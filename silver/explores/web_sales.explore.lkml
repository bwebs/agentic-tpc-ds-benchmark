include: "/bronze/explores/web_sales_base.explore.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/warehouse.view.lkml"
include: "/bronze/warehouse.refinement.lkml"
include: "/bronze/ship_mode.view.lkml"
include: "/bronze/ship_mode.refinement.lkml"
include: "/bronze/web_site.view.lkml"
include: "/bronze/web_site.refinement.lkml"
include: "/silver/prime_sk_item_ids.view.lkml"

explore: web_sales {
  extends: [web_sales_base]
  hidden: no
  label: "Web Sales"
  view_name: web_sales

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_item_sk} = ${item.i_item_sk} ;;
  }

  join: prime_sk_item_ids {
    type: left_outer
    relationship: many_to_one
    sql_on: ${item.i_item_id} = ${prime_sk_item_ids.i_item_id} ;;
  }

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_sold_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: ship_date {
    from: date_dim
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_ship_date_sk} = ${ship_date.d_date_sk} ;;
  }

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_bill_customer_sk} = ${customer.c_customer_sk} ;;
  }

  join: customer_address {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_addr_sk} = ${customer_address.ca_address_sk} ;;
  }

  join: warehouse {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_warehouse_sk} = ${warehouse.w_warehouse_sk} ;;
  }

  join: ship_mode {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_ship_mode_sk} = ${ship_mode.sm_ship_mode_sk} ;;
  }

  join: web_site {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_web_site_sk} = ${web_site.web_site_sk} ;;
  }

  query: ship_aging_by_warehouse_ship_mode_and_web_site {
    description: "Web sales shipping aging buckets grouped by 20-char warehouse name, ship mode type, and web site name for ship month seq 1222..1233."
    dimensions: [warehouse.w_warehouse_name_20, ship_mode.sm_type, web_site.web_name]
    measures: [
      web_sales.days_30,
      web_sales.days_31_60,
      web_sales.days_61_90,
      web_sales.days_91_120,
      web_sales.days_over_120
    ]
    filters: [
      ship_date.d_month_seq: "[1222, 1233]",
      warehouse.w_warehouse_sk: "NOT NULL",
      ship_mode.sm_ship_mode_sk: "NOT NULL",
      web_site.web_site_sk: "NOT NULL"
    ]
    sorts: [warehouse.w_warehouse_name_20: asc, ship_mode.sm_type: asc, web_site.web_name: asc]
    limit: 100
  }

  query: q1_2000_sales_by_zip_and_state {
    description: "Q1 2000 web sales unit price sum grouped by customer current address ZIP and state."
    dimensions: [customer_address.ca_zip, customer_address.ca_state]
    measures: [web_sales.total_sales_price]
    filters: [
      date_dim.d_year_num: "2000",
      date_dim.d_qoy: "1",
      customer.c_customer_sk: "NOT NULL",
      customer_address.ca_address_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL"
    ]
    sorts: [customer_address.ca_zip: asc, customer_address.ca_state: asc]
    limit: 100
  }
}
