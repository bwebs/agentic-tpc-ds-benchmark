include: "../../silver/explores/customer.explore.lkml"

test: customer_channel_yoy_2001_2002_cohort_metrics {
  explore_source: customer {
    column: c_customer_id { field: customer.c_customer_id }
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
    sorts: [customer.c_customer_id: asc]
  }
  assert: cohort_customer_count_matches {
    expression: count(${customer.c_customer_id}) = 4 ;;
  }
  assert: catalog_2001_total_matches {
    expression: round(sum(${customer_channel_yoy_facts.total_catalog_2001_year_total}), 2) = 29095.73 ;;
  }
  assert: catalog_2002_total_matches {
    expression: round(sum(${customer_channel_yoy_facts.total_catalog_2002_year_total}), 2) = 94634.35 ;;
  }
  assert: first_customer_ratio_positive {
    expression: ${customer_channel_yoy_facts.catalog_yoy_ratio} > 1 ;;
  }
}

test: customer_zip_prefix_31_preferred_address_metrics {
  explore_source: customer {
    column: preferred_customer_count { field: customer.preferred_customer_count }
    column: count { field: customer.count }
    filters: {
      field: customer_customer_address_fields.has_current_address_match
      value: "Yes"
    }
    filters: {
      field: customer_address.ca_zip_prefix_2
      value: "31"
    }
  }
  assert: preferred_customer_count_matches {
    expression: ${customer.preferred_customer_count} = 561 ;;
  }
  assert: customer_count_matches {
    expression: ${customer.count} = 1193 ;;
  }
}
