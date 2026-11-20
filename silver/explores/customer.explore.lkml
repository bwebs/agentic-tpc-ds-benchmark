include: "/bronze/explores/customer_base.explore.lkml"
include: "/silver/customer_channel_yoy_facts.view.lkml"
include: "/silver/customer_2002_apr_jul_channel_flags.view.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/customer_demographics.view.lkml"
include: "/bronze/customer_demographics.refinement.lkml"
include: "/silver/customer_customer_address_fields.view.lkml"

explore: customer {
  extends: [customer_base]
  hidden: no
  label: "Customer"
  view_name: customer

  join: customer_address {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_addr_sk} = ${customer_address.ca_address_sk} ;;
  }

  join: customer_demographics {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_cdemo_sk} = ${customer_demographics.cd_demo_sk} ;;
  }

  join: customer_customer_address_fields {
    sql: ;;
    relationship: one_to_one
  }

  join: customer_channel_yoy_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_customer_id} = ${customer_channel_yoy_facts.c_customer_id} ;;
  }

  join: customer_2002_apr_jul_channel_flags {
    type: left_outer
    relationship: one_to_one
    sql_on: ${customer.c_customer_sk} = ${customer_2002_apr_jul_channel_flags.customer_sk} ;;
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

  join: _sdt_date_dim {
    from: date_dim
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: demographics_by_2002_apr_jul_multichannel_activity {
    description: "2002 Apr-Jul store plus web or catalog-ship active customers by demographic profile across 5 counties"
    dimensions: [
      customer_demographics.cd_gender,
      customer_demographics.cd_marital_status,
      customer_demographics.cd_education_status,
      customer_demographics.cd_purchase_estimate,
      customer_demographics.cd_credit_rating,
      customer_demographics.cd_dep_count,
      customer_demographics.cd_dep_employed_count,
      customer_demographics.cd_dep_college_count
    ]
    measures: [customer.count]
    filters: [
      customer_address.ca_county: "Lycoming County,Sheridan County,Kandiyohi County,Pike County,Greene County",
      customer.c_current_cdemo_sk: "NOT NULL",
      customer_demographics.cd_demo_sk: "NOT NULL",
      customer_2002_apr_jul_channel_flags.has_store_sales: "Yes",
      customer_2002_apr_jul_channel_flags.has_web_or_catalog_ship_sales: "Yes"
    ]
    sorts: [
      customer_demographics.cd_gender: asc,
      customer_demographics.cd_marital_status: asc,
      customer_demographics.cd_education_status: asc,
      customer_demographics.cd_purchase_estimate: asc,
      customer_demographics.cd_credit_rating: asc,
      customer_demographics.cd_dep_count: asc,
      customer_demographics.cd_dep_employed_count: asc,
      customer_demographics.cd_dep_college_count: asc
    ]
    limit: 100
  }

  query: catalog_yoy_outpacing_store_and_web_2001_2002 {
    description: "Customers with positive 2001 spend in store, catalog, and web whose 2002/2001 catalog growth ratio exceeds both store and web"
    dimensions: [customer.c_customer_id, customer.c_first_name, customer.c_last_name, customer.c_preferred_cust_flag]
    filters: [
      customer_channel_yoy_facts.is_catalog_yoy_outpacing_store_and_web: "Yes",
      customer_channel_yoy_facts.c_customer_id: "-NULL"
    ]
    sorts: [customer.c_customer_id: asc]
    limit: 100
  }
}
