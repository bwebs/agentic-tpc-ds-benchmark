include: "/bronze/explores/catalog_sales_base.explore.lkml"
include: "/bronze/call_center.view.lkml"
include: "/bronze/call_center.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/customer_demographics.view.lkml"
include: "/bronze/customer_demographics.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/promotion.view.lkml"
include: "/bronze/promotion.refinement.lkml"
include: "/silver/catalog_order_return_facts.view.lkml"
include: "/silver/catalog_order_warehouse_facts.view.lkml"
include: "/silver/catalog_sales_customer_address_fields.view.lkml"

explore: catalog_sales {
  extends: [catalog_sales_base]
  hidden: no
  label: "Catalog Sales"
  view_name: catalog_sales

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_sales.cs_bill_customer_sk} = ${customer.c_customer_sk} ;;
  }

  join: customer_address {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_addr_sk} = ${customer_address.ca_address_sk} ;;
  }

  join: ship_customer_address {
    from: customer_address
    view_label: "Ship Customer Address"
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_sales.cs_ship_addr_sk} = ${ship_customer_address.ca_address_sk} ;;
  }

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_sales.cs_sold_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: ship_date_dim {
    from: date_dim
    view_label: "Ship Date"
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_sales.cs_ship_date_sk} = ${ship_date_dim.d_date_sk} ;;
  }

  join: call_center {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_sales.cs_call_center_sk} = ${call_center.cc_call_center_sk} ;;
  }

  join: catalog_order_warehouse_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_sales.cs_order_number} = ${catalog_order_warehouse_facts.cs_order_number} ;;
  }

  join: catalog_order_return_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_sales.cs_order_number} = ${catalog_order_return_facts.cr_order_number} ;;
  }

  join: catalog_sales_customer_address_fields {
    sql: ;;
    relationship: one_to_one
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_sales.cs_item_sk} = ${item.i_item_sk} ;;
  }

  join: cd1 {
    from: customer_demographics
    view_label: "Bill Customer Demographics"
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_sales.cs_bill_cdemo_sk} = ${cd1.cd_demo_sk} ;;
  }

  join: cd2 {
    from: customer_demographics
    view_label: "Current Customer Demographics"
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_cdemo_sk} = ${cd2.cd_demo_sk} ;;
  }

  join: promotion {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_sales.cs_promo_sk} = ${promotion.p_promo_sk} ;;
  }

  query: promotional_item_averages_2000_demographic_cohort {
    description: "2000 catalog sales average quantity, list price, coupon amount, and sales price by item ID for widowed female secondary-educated bill demographics on non-email or non-event promotions"
    dimensions: [item.i_item_id]
    measures: [
      catalog_sales.average_quantity,
      catalog_sales.average_list_price,
      catalog_sales.average_coupon_amount,
      catalog_sales.average_sales_price
    ]
    filters: [
      date_dim.d_year_num: "2000",
      cd1.cd_gender: "F",
      cd1.cd_marital_status: "W",
      cd1.cd_education_status: "Secondary",
      promotion.is_non_email_or_non_event_channel: "Yes",
      catalog_sales.cs_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      catalog_sales.cs_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      catalog_sales.cs_bill_cdemo_sk: "NOT NULL",
      cd1.cd_demo_sk: "NOT NULL",
      catalog_sales.cs_promo_sk: "NOT NULL",
      promotion.p_promo_sk: "NOT NULL"
    ]
    sorts: [item.i_item_id: asc]
    limit: 100
  }

  query: female_secondary_ed_2001_averages_by_item_and_county {
    description: "2001 catalog sales averages by item and county for female secondary-educated bill demographics and target customer states/birth months"
    dimensions: [
      item.i_item_id,
      customer_address.ca_country,
      customer_address.ca_state,
      customer_address.ca_county
    ]
    measures: [
      catalog_sales.average_quantity,
      catalog_sales.average_list_price,
      catalog_sales.average_coupon_amount,
      catalog_sales.average_sales_price,
      catalog_sales.average_net_profit,
      customer.average_birth_year,
      cd1.average_dependent_count
    ]
    filters: [
      cd1.cd_gender: "F",
      cd1.cd_education_status: "Secondary",
      customer.c_birth_month: "8, 4, 2, 5, 11, 9",
      date_dim.d_year_num: "2001",
      customer_address.ca_state: "KS,IA,AL,UT,VA,NC,TX",
      catalog_sales.cs_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      catalog_sales.cs_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      catalog_sales.cs_bill_cdemo_sk: "NOT NULL",
      cd1.cd_demo_sk: "NOT NULL",
      catalog_sales.cs_bill_customer_sk: "NOT NULL",
      customer.c_customer_sk: "NOT NULL",
      customer.c_current_cdemo_sk: "NOT NULL",
      cd2.cd_demo_sk: "NOT NULL",
      customer.c_current_addr_sk: "NOT NULL",
      customer_address.ca_address_sk: "NOT NULL"
    ]
    sorts: [
      customer_address.ca_country: asc,
      customer_address.ca_state: asc,
      customer_address.ca_county: asc,
      item.i_item_id: asc
    ]
    limit: 100
  }

  query: multi_warehouse_unreturned_orders_2002 {
    description: "Multi-warehouse catalog orders without returns shipped between 2002-03-01 and 2002-05-01 to IA via Williamson County call centers"
    measures: [
      catalog_sales.order_count,
      catalog_sales.total_shipping_cost,
      catalog_sales.total_net_profit
    ]
    filters: [
      ship_date_dim.d_date: "2002-03-01 to 2002-05-02",
      ship_customer_address.ca_state: "IA",
      call_center.cc_county: "Williamson County",
      catalog_sales.cs_warehouse_sk: "NOT NULL",
      catalog_order_warehouse_facts.is_multi_warehouse_order: "Yes",
      catalog_order_return_facts.cr_order_number: "NULL"
    ]
    sorts: [catalog_sales.order_count: asc]
    limit: 100
  }

  query: q1_1998_sales_by_zip {
    description: "Q1 1998 total catalog sales price by customer postal code for target zip codes, CA/WA/GA states, or items over $500"
    dimensions: [customer_address.ca_zip]
    measures: [catalog_sales.total_sales_price]
    filters: [
      date_dim.d_qoy: "1",
      date_dim.d_year_num: "1998",
      catalog_sales_customer_address_fields.is_target_zip_state_or_high_price: "Yes",
      catalog_sales.cs_bill_customer_sk: "NOT NULL",
      customer.c_customer_sk: "NOT NULL",
      customer.c_current_addr_sk: "NOT NULL",
      customer_address.ca_address_sk: "NOT NULL",
      catalog_sales.cs_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL"
    ]
    sorts: [customer_address.ca_zip: asc]
    limit: 100
  }
}
