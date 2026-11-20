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

test: customer_demographics_sk_1_to_1m_dependent_dispersion_metrics {
  explore_source: customer_demographics {
    column: count { field: customer_demographics.count }
    column: max_dependent_count { field: customer_demographics.max_dependent_count }
    column: stddev_dependent_count { field: customer_demographics.stddev_dependent_count }
    column: average_employed_dependent_count { field: customer_demographics.average_employed_dependent_count }
    column: max_employed_dependent_count { field: customer_demographics.max_employed_dependent_count }
    column: stddev_employed_dependent_count { field: customer_demographics.stddev_employed_dependent_count }
    column: average_college_dependent_count { field: customer_demographics.average_college_dependent_count }
    column: max_college_dependent_count { field: customer_demographics.max_college_dependent_count }
    column: stddev_college_dependent_count { field: customer_demographics.stddev_college_dependent_count }
    filters: {
      field: customer_demographics.cd_demo_sk
      value: "[1, 1000000]"
    }
  }
  assert: dependent_dispersion_matches {
    expression: ${customer_demographics.count} = 1000000
      AND ${customer_demographics.max_dependent_count} = 6
      AND round(${customer_demographics.stddev_dependent_count}, 4) = 1.9993 ;;
  }
  assert: employed_dependent_dispersion_matches {
    expression: round(${customer_demographics.average_employed_dependent_count}, 4) = 2.7848
      AND ${customer_demographics.max_employed_dependent_count} = 6
      AND round(${customer_demographics.stddev_employed_dependent_count}, 4) = 1.9533 ;;
  }
  assert: college_dependent_dispersion_matches {
    expression: round(${customer_demographics.average_college_dependent_count}, 4) = 1.3536
      AND ${customer_demographics.max_college_dependent_count} = 3
      AND round(${customer_demographics.stddev_college_dependent_count}, 4) = 1.0635 ;;
  }
}
