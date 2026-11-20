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
include: "/bronze/web_returns.view.lkml"
include: "/bronze/web_returns.refinement.lkml"
include: "/bronze/web_page.view.lkml"
include: "/bronze/web_page.refinement.lkml"
include: "/bronze/customer_demographics.view.lkml"
include: "/bronze/customer_demographics.refinement.lkml"
include: "/bronze/reason.view.lkml"
include: "/bronze/reason.refinement.lkml"
include: "/bronze/time_dim.view.lkml"
include: "/bronze/time_dim.refinement.lkml"
include: "/bronze/household_demographics.view.lkml"
include: "/bronze/household_demographics.refinement.lkml"
include: "/silver/prime_sk_item_ids.view.lkml"
include: "/silver/time_dim_web_sales_fields.view.lkml"
include: "/silver/web_order_return_facts.view.lkml"
include: "/silver/web_order_warehouse_facts.view.lkml"

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

  join: web_returns {
    type: left_outer
    relationship: one_to_one
    sql_on: ${web_sales.ws_item_sk} = ${web_returns.wr_item_sk}
      AND ${web_sales.ws_order_number} = ${web_returns.wr_order_number} ;;
  }

  join: web_page {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_web_page_sk} = ${web_page.wp_web_page_sk} ;;
  }

  join: cd1 {
    from: customer_demographics
    view_label: "Refunded Customer Demographics"
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_returns.wr_refunded_cdemo_sk} = ${cd1.cd_demo_sk} ;;
  }

  join: cd2 {
    from: customer_demographics
    view_label: "Returning Customer Demographics"
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_returns.wr_returning_cdemo_sk} = ${cd2.cd_demo_sk} ;;
  }

  join: refunded_address {
    from: customer_address
    view_label: "Refunded Customer Address"
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_returns.wr_refunded_addr_sk} = ${refunded_address.ca_address_sk} ;;
  }

  join: reason {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_returns.wr_reason_sk} = ${reason.r_reason_sk} ;;
  }

  join: time_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_sold_time_sk} = ${time_dim.t_time_sk} ;;
  }

  join: ship_household_demographics {
    from: household_demographics
    view_label: "Ship Household Demographics"
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_ship_hdemo_sk} = ${ship_household_demographics.hd_demo_sk} ;;
  }

  join: time_dim_web_sales_fields {
    sql: ;;
    relationship: one_to_one
  }

  join: ship_customer_address {
    from: customer_address
    view_label: "Ship Customer Address"
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_ship_addr_sk} = ${ship_customer_address.ca_address_sk} ;;
  }

  join: web_order_warehouse_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_order_number} = ${web_order_warehouse_facts.ws_order_number} ;;
  }

  join: web_order_return_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_order_number} = ${web_order_return_facts.wr_order_number} ;;
  }

  query: multi_warehouse_unreturned_orders_2000 {
    description: "Multi-warehouse web orders without returns shipped between 2000-03-01 and 2000-05-01 to MT via pri company web sites."
    measures: [
      web_sales.order_count,
      web_sales.total_shipping_cost,
      web_sales.total_net_profit
    ]
    filters: [
      ship_date.d_date: "2000-03-01 to 2000-05-02",
      ship_customer_address.ca_state: "MT",
      web_site.web_company_name: "pri",
      web_sales.ws_warehouse_sk: "NOT NULL",
      web_order_warehouse_facts.is_multi_warehouse_order: "Yes",
      web_order_return_facts.wr_order_number: "NULL"
    ]
    sorts: [web_sales.order_count: asc]
    limit: 100
  }

  query: am_pm_sales_ratio_dep_8_char_5000_5200 {
    description: "Ratio of web sales count in hours 12-13 to hours 20-21 for ship household dependent count 8 and web page character count 5000..5200."
    measures: [time_dim_web_sales_fields.am_pm_sales_ratio]
    filters: [
      ship_household_demographics.hd_dep_count: "8",
      web_page.wp_char_count: "[5000, 5200]",
      time_dim.t_hour: "[12, 13], [20, 21]"
    ]
    sorts: [time_dim_web_sales_fields.am_pm_sales_ratio: asc]
    limit: 100
  }

  query: net_paid_by_category_and_class_month_seq_1183_1194 {
    description: "Web sales total net paid grouped by item category and class for sold month sequence 1183..1194."
    dimensions: [item.i_category, item.i_class]
    measures: [web_sales.total_net_paid]
    filters: [
      date_dim.d_month_seq: "[1183, 1194]",
      item.i_item_sk: "NOT NULL"
    ]
    sorts: [item.i_category: asc]
    limit: 100
  }

  query: web_returns_2001_averages_by_reason {
    description: "2001 average web sales quantity, refunded cash, and return fee by return reason across US state and matching refunded/returning demographic tiers."
    dimensions: [reason.r_reason_desc_20]
    measures: [
      web_sales.average_quantity,
      web_returns.average_refunded_cash,
      web_returns.average_fee
    ]
    filters: [
      date_dim.d_year_num: "2001",
      refunded_address.ca_country: "United States",
      refunded_address.ca_state: "KY, ME, IL, OK, NE, MN, FL, WI, KS",
      cd1.cd_marital_status: "W, D, M",
      cd1.cd_education_status: "Primary, Secondary, Advanced Degree",
      web_sales.ws_sales_price: "[50, 200]",
      web_sales.ws_net_profit: "[50, 300]",
      web_page.wp_web_page_sk: "NOT NULL",
      web_returns.wr_item_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      cd1.cd_demo_sk: "NOT NULL",
      cd2.cd_demo_sk: "NOT NULL",
      refunded_address.ca_address_sk: "NOT NULL",
      reason.r_reason_sk: "NOT NULL"
    ]
    sorts: [
      reason.r_reason_desc_20: asc,
      web_sales.average_quantity: asc,
      web_returns.average_refunded_cash: asc,
      web_returns.average_fee: asc
    ]
    limit: 100
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
