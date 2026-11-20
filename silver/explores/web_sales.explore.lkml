include: "/bronze/explores/web_sales_base.explore.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
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
