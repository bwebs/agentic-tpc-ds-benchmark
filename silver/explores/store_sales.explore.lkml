include: "/bronze/explores/store_sales_base.explore.lkml"
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
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"
include: "/bronze/household_demographics.view.lkml"
include: "/bronze/household_demographics.refinement.lkml"
include: "/silver/item_category_price_facts.view.lkml"
include: "/silver/item_item_category_price_facts_fields.view.lkml"
include: "/silver/customer_demographics_household_demographics_store_sales_fields.view.lkml"
include: "/silver/sales_customer_address_store_sales_fields.view.lkml"
include: "/silver/customer_address_store_fields.view.lkml"

explore: store_sales {
  extends: [store_sales_base]
  hidden: no
  label: "Store Sales"
  view_name: store_sales

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_sales.ss_customer_sk} = ${customer.c_customer_sk} ;;
  }

  join: customer_address {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_addr_sk} = ${customer_address.ca_address_sk} ;;
  }

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_sales.ss_sold_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_sales.ss_item_sk} = ${item.i_item_sk} ;;
  }

  join: item_category_price_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${item.i_category} = ${item_category_price_facts.i_category} ;;
  }

  join: item_item_category_price_facts_fields {
    sql: ;;
    relationship: one_to_one
  }

  join: customer_demographics {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_sales.ss_cdemo_sk} = ${customer_demographics.cd_demo_sk} ;;
  }

  join: promotion {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_sales.ss_promo_sk} = ${promotion.p_promo_sk} ;;
  }

  join: store {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_sales.ss_store_sk} = ${store.s_store_sk} ;;
  }

  join: household_demographics {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_sales.ss_hdemo_sk} = ${household_demographics.hd_demo_sk} ;;
  }

  join: sales_customer_address {
    from: customer_address
    view_label: "Sales Customer Address"
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_sales.ss_addr_sk} = ${sales_customer_address.ca_address_sk} ;;
  }

  join: customer_demographics_household_demographics_store_sales_fields {
    sql: ;;
    relationship: one_to_one
  }

  join: sales_customer_address_store_sales_fields {
    sql: ;;
    relationship: one_to_one
  }

  join: customer_address_store_fields {
    sql: ;;
    relationship: one_to_one
  }

  query: category_class_gross_margin_2000_tn {
    description: "2000 store sales gross margin by item category and item class for Tennessee stores"
    dimensions: [item.i_category, item.i_class]
    measures: [store_sales.gross_margin]
    filters: [
      date_dim.d_year_num: "2000",
      store.s_state: "TN",
      store_sales.ss_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      store_sales.ss_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      store_sales.ss_store_sk: "NOT NULL",
      store.s_store_sk: "NOT NULL"
    ]
    sorts: [item.i_category: asc]
    limit: 100
  }

  query: williamson_county_ticket_counts_1999_2001_high_dep_ratio {
    description: "Customer details and line-item counts (15 to 20) per store sales ticket in Williamson County across 1999-2001 on days 1-3 or 25-28 for households with >10000 or unknown buy potential and dependent-to-vehicle ratio > 1.2"
    dimensions: [
      customer.c_last_name,
      customer.c_first_name,
      customer.c_salutation,
      customer.c_preferred_cust_flag,
      store_sales.ss_ticket_number,
      store_sales.ss_customer_sk
    ]
    measures: [store_sales.count]
    filters: [
      date_dim.d_dom: "[1, 3], [25, 28]",
      date_dim.d_year_num: "1999, 2000, 2001",
      store.s_county: "Williamson County",
      household_demographics.hd_buy_potential: ">10000,unknown",
      household_demographics.hd_vehicle_count: ">0",
      household_demographics.is_dep_to_vehicle_ratio_over_1_2: "Yes",
      store_sales.count: "[15, 20]",
      store_sales.ss_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      store_sales.ss_store_sk: "NOT NULL",
      store.s_store_sk: "NOT NULL",
      store_sales.ss_hdemo_sk: "NOT NULL",
      household_demographics.hd_demo_sk: "NOT NULL",
      store_sales.ss_customer_sk: "NOT NULL",
      customer.c_customer_sk: "NOT NULL"
    ]
    sorts: [
      customer.c_last_name: asc,
      customer.c_first_name: asc,
      customer.c_salutation: asc,
      customer.c_preferred_cust_flag: desc
    ]
    limit: 500
  }

  query: quantity_price_bucket_list_price_summary {
    description: "Average, count, and distinct count of list price across six mutually exclusive store sales quantity and price/coupon/wholesale buckets (B1..B6)"
    measures: [
      store_sales.b1_lp,
      store_sales.b1_cnt,
      store_sales.b1_cntd,
      store_sales.b2_lp,
      store_sales.b2_cnt,
      store_sales.b2_cntd,
      store_sales.b3_lp,
      store_sales.b3_cnt,
      store_sales.b3_cntd,
      store_sales.b4_lp,
      store_sales.b4_cnt,
      store_sales.b4_cntd,
      store_sales.b5_lp,
      store_sales.b5_cnt,
      store_sales.b5_cntd,
      store_sales.b6_lp,
      store_sales.b6_cnt,
      store_sales.b6_cntd
    ]
    limit: 100
  }

  query: item_state_averages_2000_demographic_cohort {
    description: "2000 average quantity, list price, coupon amount, and sales price by item ID and store state for divorced male college-educated customers in TN"
    dimensions: [item.i_item_id, store.s_state]
    measures: [
      store_sales.average_quantity,
      store_sales.average_list_price,
      store_sales.average_coupon_amount,
      store_sales.average_sales_price
    ]
    filters: [
      date_dim.d_year_num: "2000",
      customer_demographics.cd_gender: "M",
      customer_demographics.cd_marital_status: "D",
      customer_demographics.cd_education_status: "College",
      store.s_state: "TN",
      store_sales.ss_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      store_sales.ss_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      store_sales.ss_store_sk: "NOT NULL",
      store.s_store_sk: "NOT NULL",
      store_sales.ss_cdemo_sk: "NOT NULL",
      customer_demographics.cd_demo_sk: "NOT NULL"
    ]
    sorts: [item.i_item_id: asc, store.s_state: asc]
    limit: 100
  }

  query: dec_1998_out_of_zip_brand_manufact_sales_manager_38 {
    description: "December 1998 extended sales price by brand and manufacturer for manager 38 items where customer 5-digit zip differs from store 5-digit zip"
    dimensions: [
      item.i_brand_id,
      item.i_brand,
      item.i_manufact_id,
      item.i_manufact
    ]
    measures: [store_sales.total_ext_sales_price]
    filters: [
      item.i_manager_id: "38",
      date_dim.d_moy: "12",
      date_dim.d_year_num: "1998",
      customer_address_store_fields.is_different_zip_5: "Yes",
      store_sales.ss_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      store_sales.ss_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      store_sales.ss_customer_sk: "NOT NULL",
      customer.c_customer_sk: "NOT NULL",
      customer.c_current_addr_sk: "NOT NULL",
      customer_address.ca_address_sk: "NOT NULL",
      store_sales.ss_store_sk: "NOT NULL",
      store.s_store_sk: "NOT NULL"
    ]
    sorts: [
      store_sales.total_ext_sales_price: desc,
      item.i_brand: asc,
      item.i_brand_id: asc,
      item.i_manufact_id: asc,
      item.i_manufact: asc
    ]
    limit: 100
  }

  query: store_sales_2001_demographic_address_profit_summary {
    description: "2001 average quantity, extended sales price, and extended wholesale cost (average and sum) across qualifying demographic sales price and US state net profit tiers"
    measures: [
      store_sales.average_quantity,
      store_sales.average_ext_sales_price,
      store_sales.average_ext_wholesale_cost,
      store_sales.total_ext_wholesale_cost
    ]
    filters: [
      date_dim.d_year_num: "2001",
      customer_demographics_household_demographics_store_sales_fields.is_qualifying_demographic_sales_price_tier: "Yes",
      sales_customer_address_store_sales_fields.is_qualifying_us_state_net_profit_tier: "Yes",
      store_sales.ss_store_sk: "NOT NULL",
      store.s_store_sk: "NOT NULL",
      store_sales.ss_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      store_sales.ss_hdemo_sk: "NOT NULL",
      household_demographics.hd_demo_sk: "NOT NULL",
      store_sales.ss_cdemo_sk: "NOT NULL",
      customer_demographics.cd_demo_sk: "NOT NULL",
      store_sales.ss_addr_sk: "NOT NULL",
      sales_customer_address.ca_address_sk: "NOT NULL"
    ]
    limit: 500
  }

  query: quantity_bucket_conditional_averages {
    description: "Conditional average extended list price vs net profit across five store sales quantity buckets (1-20, 21-40, 41-60, 61-80, 81-100)"
    measures: [
      store_sales.bucket1,
      store_sales.bucket2,
      store_sales.bucket3,
      store_sales.bucket4,
      store_sales.bucket5
    ]
    limit: 500
  }

  query: promotional_item_averages_1998_demographic_cohort {
    description: "1998 average quantity, list price, coupon amount, and sales price by item ID for widowed female 2-yr degree customers on non-email or non-event promotions"
    dimensions: [item.i_item_id]
    measures: [
      store_sales.average_quantity,
      store_sales.average_list_price,
      store_sales.average_coupon_amount,
      store_sales.average_sales_price
    ]
    filters: [
      date_dim.d_year_num: "1998",
      customer_demographics.cd_gender: "F",
      customer_demographics.cd_marital_status: "W",
      customer_demographics.cd_education_status: "2 yr Degree",
      promotion.is_non_email_or_non_event_channel: "Yes",
      store_sales.ss_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      store_sales.ss_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      store_sales.ss_cdemo_sk: "NOT NULL",
      customer_demographics.cd_demo_sk: "NOT NULL",
      store_sales.ss_promo_sk: "NOT NULL",
      promotion.p_promo_sk: "NOT NULL"
    ]
    sorts: [item.i_item_id: asc]
    limit: 100
  }

  query: july_1998_high_price_item_sales_by_state {
    description: "July 1998 store sales count by customer state for items priced above 120% of category average (min 10 sales)"
    dimensions: [customer_address.ca_state]
    measures: [store_sales.count]
    filters: [
      date_dim.d_year_num: "1998",
      date_dim.d_moy: "7",
      date_dim.d_month_seq: "NOT NULL",
      item.i_category: "-NULL",
      item_item_category_price_facts_fields.is_above_120pct_category_avg_price: "Yes",
      store_sales.ss_customer_sk: "NOT NULL",
      customer.c_customer_sk: "NOT NULL",
      customer.c_current_addr_sk: "NOT NULL",
      customer_address.ca_address_sk: "NOT NULL",
      store_sales.ss_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      store_sales.ss_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      store_sales.count: ">=10"
    ]
    sorts: [store_sales.count: asc]
    limit: 100
  }

  query: november_brand_discount_sales_manufact_427 {
    description: "November store sales extended discount amount by year and brand for manufacturer 427"
    dimensions: [date_dim.d_year_num, item.i_brand_id, item.i_brand]
    measures: [store_sales.total_extended_discount_amount]
    filters: [
      item.i_manufact_id: "427",
      date_dim.d_moy: "11",
      store_sales.ss_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      store_sales.ss_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL"
    ]
    sorts: [
      date_dim.d_year_num: asc,
      store_sales.total_extended_discount_amount: desc,
      item.i_brand_id: asc
    ]
    limit: 100
  }
}
