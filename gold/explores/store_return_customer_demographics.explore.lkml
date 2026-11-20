include: "/gold/store_return_customer_demographics.view.lkml"
include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/customer_demographics.view.lkml"
include: "/bronze/customer_demographics.refinement.lkml"
include: "/bronze/household_demographics.view.lkml"
include: "/bronze/household_demographics.refinement.lkml"
include: "/bronze/income_band.view.lkml"
include: "/bronze/income_band.refinement.lkml"

explore: store_return_customer_demographics {
  view_name: store_return_customer_demographics
  label: "Store Return Customer Demographics"
  tags: ["gold"]

  join: _sdt_sr {
    from: store_returns
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

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_return_customer_demographics.c_customer_sk} = ${customer.c_customer_sk} ;;
  }

  join: customer_address {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_addr_sk} = ${customer_address.ca_address_sk} ;;
  }

  join: customer_demographics {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_return_customer_demographics.sr_cdemo_sk} = ${customer_demographics.cd_demo_sk} ;;
  }

  join: household_demographics {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_hdemo_sk} = ${household_demographics.hd_demo_sk} ;;
  }

  join: income_band {
    type: left_outer
    relationship: many_to_one
    sql_on: ${household_demographics.hd_income_band_sk} = ${income_band.ib_income_band_sk} ;;
  }

  query: green_acres_mid_income_return_demographic_customers {
    description: "Customers in Green Acres with household income band bounds between 54,986 and 104,986 matched to store return customer demographics"
    dimensions: [
      customer.c_customer_id,
      customer.customer_full_name,
      store_return_customer_demographics.pk
    ]
    filters: [
      customer_address.ca_city: "Green Acres",
      customer_demographics.cd_demo_sk: "NOT NULL",
      income_band.ib_lower_bound: ">=54986",
      income_band.ib_upper_bound: "<=104986"
    ]
    sorts: [customer.c_customer_id: asc]
    limit: 100
  }
}
