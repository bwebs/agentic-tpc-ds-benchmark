include: "../../silver/explores/customer.explore.lkml"

test: customer_sk_le_1000_preferred_metrics {
  explore_source: customer {
    column: preferred_customer_count { field: customer.preferred_customer_count }
    column: count { field: customer.count }
    filters: {
      field: customer.c_customer_sk
      value: "<=1000"
    }
  }
  assert: preferred_customer_count_matches {
    expression: ${customer.preferred_customer_count} = 494 ;;
  }
  assert: customer_count_matches {
    expression: ${customer.count} = 1000 ;;
  }
}

test: customer_sk_le_1000_birth_year_metrics {
  explore_source: customer {
    column: average_birth_year { field: customer.average_birth_year }
    column: count { field: customer.count }
    filters: {
      field: customer.c_customer_sk
      value: "<=1000"
    }
  }
  assert: average_birth_year_matches {
    expression: round(${customer.average_birth_year}, 2) = 1957.52 ;;
  }
  assert: customer_count_matches {
    expression: ${customer.count} = 1000 ;;
  }
}
