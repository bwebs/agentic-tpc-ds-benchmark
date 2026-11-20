include: "/gold/catalog_customer_total_return.view.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"

explore: catalog_customer_total_return {
  view_name: catalog_customer_total_return
  label: "Catalog Customer Total Return"
  tags: ["gold"]

  always_filter: {
    filters: [catalog_customer_total_return.return_year_filter: "1999"]
  }

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_customer_total_return.ctr_customer_sk} = ${customer.c_customer_sk} ;;
  }

  join: customer_address {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_addr_sk} = ${customer_address.ca_address_sk} ;;
  }

  query: high_catalog_return_customers_by_current_state {
    description: "Customers currently living in TX whose 1999 catalog return total including tax in a returning state exceeds 120% of that returning state's average customer catalog return"
    dimensions: [
      customer.c_customer_id,
      customer.c_salutation,
      customer.c_first_name,
      customer.c_last_name,
      customer_address.ca_street_number,
      customer_address.ca_street_name,
      customer_address.ca_street_type,
      customer_address.ca_suite_number,
      customer_address.ca_city,
      customer_address.ca_county,
      customer_address.ca_state,
      customer_address.ca_zip,
      customer_address.ca_country,
      customer_address.ca_gmt_offset,
      customer_address.ca_location_type,
      catalog_customer_total_return.ctr_total_return
    ]
    filters: [
      catalog_customer_total_return.return_year_filter: "1999",
      customer_address.ca_state: "TX",
      catalog_customer_total_return.is_above_state_return_limit: "Yes",
      catalog_customer_total_return.ctr_state: "-NULL",
      customer.c_customer_sk: "NOT NULL",
      customer_address.ca_address_sk: "NOT NULL"
    ]
    sorts: [
      customer.c_customer_id: asc,
      customer.c_salutation: asc,
      customer.c_first_name: asc,
      customer.c_last_name: asc,
      customer_address.ca_street_number: asc,
      customer_address.ca_street_name: asc,
      customer_address.ca_street_type: asc,
      customer_address.ca_suite_number: asc,
      customer_address.ca_city: asc,
      customer_address.ca_county: asc,
      customer_address.ca_state: asc,
      customer_address.ca_zip: asc,
      customer_address.ca_country: asc,
      customer_address.ca_gmt_offset: asc,
      customer_address.ca_location_type: asc,
      catalog_customer_total_return.ctr_total_return: asc
    ]
    limit: 100
  }
}
