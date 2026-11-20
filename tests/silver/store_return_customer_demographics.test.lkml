include: "../../gold/explores/store_return_customer_demographics.explore.lkml"

test: store_return_customer_demographics_green_acres_mid_income_metrics {
  explore_source: store_return_customer_demographics {
    column: count { field: store_return_customer_demographics.count }
    filters: {
      field: customer_address.ca_city
      value: "Green Acres"
    }
    filters: {
      field: customer_demographics.cd_demo_sk
      value: "NOT NULL"
    }
    filters: {
      field: income_band.ib_lower_bound
      value: ">=54986"
    }
    filters: {
      field: income_band.ib_upper_bound
      value: "<=104986"
    }
  }
  assert: row_count_matches {
    expression: ${store_return_customer_demographics.count} = 28 ;;
  }
}
