include: "../../bronze/explores/customer_demographics.explore.lkml"

test: customer_demographics_sk_le_1000_dependent_metrics {
  explore_source: customer_demographics {
    column: average_dependent_count { field: customer_demographics.average_dependent_count }
    column: count { field: customer_demographics.count }
    filters: {
      field: customer_demographics.cd_demo_sk
      value: "<=1000"
    }
  }
  assert: average_dependent_count_matches {
    expression: round(${customer_demographics.average_dependent_count}, 2) = 0 ;;
  }
  assert: customer_demographics_count_matches {
    expression: ${customer_demographics.count} = 1000 ;;
  }
}
