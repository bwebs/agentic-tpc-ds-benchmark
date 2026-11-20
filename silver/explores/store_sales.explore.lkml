include: "/bronze/explores/store_sales_base.explore.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/silver/item_category_price_facts.view.lkml"
include: "/silver/item_item_category_price_facts_fields.view.lkml"

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
