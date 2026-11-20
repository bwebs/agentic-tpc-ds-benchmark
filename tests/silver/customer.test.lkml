include: "../../silver/explores/customer.explore.lkml"

test: customer_channel_yoy_2001_2002_cohort_metrics {
  explore_source: customer {
    column: count { field: customer.count }
    column: total_catalog_2001_year_total { field: customer_channel_yoy_facts.total_catalog_2001_year_total }
    column: total_catalog_2002_year_total { field: customer_channel_yoy_facts.total_catalog_2002_year_total }
    column: catalog_yoy_ratio { field: customer_channel_yoy_facts.catalog_yoy_ratio }
    filters: {
      field: customer_channel_yoy_facts.is_catalog_yoy_outpacing_store_and_web
      value: "Yes"
    }
    filters: {
      field: customer_channel_yoy_facts.c_customer_id
      value: "-NULL"
    }
    filters: {
      field: customer.c_customer_sk
      value: "<=50000"
    }
  }
  assert: cohort_customer_count_matches {
    expression: ${customer.count} = 4 ;;
  }
  assert: catalog_2001_total_matches {
    expression: round(${customer_channel_yoy_facts.total_catalog_2001_year_total}, 2) = 29095.73 ;;
  }
  assert: catalog_2002_total_matches {
    expression: round(${customer_channel_yoy_facts.total_catalog_2002_year_total}, 2) = 94634.35 ;;
  }
  assert: catalog_yoy_ratio_matches {
    expression: round(${customer_channel_yoy_facts.catalog_yoy_ratio}, 4) = 3.2525 ;;
  }
}
