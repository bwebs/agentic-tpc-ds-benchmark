include: "/gold/customer_store_return_facts.view.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"
include: "/bronze/common_helpers.view.lkml"

explore: customer_store_return_benchmark {
  view_name: customer_store_return_facts
  label: "Customer Store Return Benchmark"
  tags: ["gold"]
  cancel_grouping_fields: [common_helpers.no_group]

  always_filter: {
    filters: [customer_store_return_facts.return_year_filter: "2001"]
  }

  join: store {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer_store_return_facts.sr_store_sk} = ${store.s_store_sk} ;;
  }

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer_store_return_facts.sr_customer_sk} = ${customer.c_customer_sk} ;;
  }

  join: common_helpers {
    sql: ;;
    relationship: one_to_one
  }

  query: high_return_customers_by_state {
    description: "Customers whose store return total exceeds 120% of the store's average customer return"
    dimensions: [customer.c_customer_id]
    filters: [
      customer_store_return_facts.return_year_filter: "2001",
      store.s_state: "TN",
      customer_store_return_facts.is_above_store_return_limit: "Yes",
      store.s_store_sk: "NOT NULL",
      customer.c_customer_sk: "NOT NULL"
    ]
    sorts: [customer.c_customer_id: asc]
    limit: 100
  }
}
