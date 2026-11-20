include: "/gold/web_customer_total_return.view.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"

explore: web_customer_total_return {
  view_name: web_customer_total_return
  label: "Web Customer Total Return"
  tags: ["gold"]

  always_filter: {
    filters: [web_customer_total_return.return_year_filter: "2000"]
  }

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_customer_total_return.ctr_customer_sk} = ${customer.c_customer_sk} ;;
  }

  join: customer_address {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_addr_sk} = ${customer_address.ca_address_sk} ;;
  }

  query: high_web_return_customers_by_current_state {
    description: "Customers currently living in IN whose 2000 web return total in a returning state exceeds 120% of that returning state's average customer web return"
    dimensions: [
      customer.c_customer_id,
      customer.c_salutation,
      customer.c_first_name,
      customer.c_last_name,
      customer.c_preferred_cust_flag,
      customer.c_birth_day,
      customer.c_birth_month,
      customer.c_birth_year,
      customer.c_birth_country,
      customer.c_login,
      customer.c_email_address,
      customer.c_last_review_date_sk,
      web_customer_total_return.ctr_total_return
    ]
    filters: [
      web_customer_total_return.return_year_filter: "2000",
      customer_address.ca_state: "IN",
      web_customer_total_return.is_above_state_return_limit: "Yes",
      web_customer_total_return.ctr_state: "-NULL",
      customer.c_customer_sk: "NOT NULL",
      customer_address.ca_address_sk: "NOT NULL"
    ]
    sorts: [
      customer.c_customer_id: asc,
      customer.c_salutation: asc,
      customer.c_first_name: asc,
      customer.c_last_name: asc,
      customer.c_preferred_cust_flag: asc,
      customer.c_birth_day: asc,
      customer.c_birth_month: asc,
      customer.c_birth_year: asc,
      customer.c_birth_country: asc,
      customer.c_login: asc,
      customer.c_email_address: asc,
      customer.c_last_review_date_sk: asc,
      web_customer_total_return.ctr_total_return: asc
    ]
    limit: 100
  }
}
