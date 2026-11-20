include: "/bronze/explores/catalog_sales_base.explore.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
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

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_sales.cs_sold_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: catalog_sales_customer_address_fields {
    sql: ;;
    relationship: one_to_one
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
