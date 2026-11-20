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

test: customer_2002_apr_jul_multichannel_demographics_metrics {
  explore_source: customer {
    column: cd_gender { field: customer_demographics.cd_gender }
    column: count { field: customer.count }
    column: channel_flag_count { field: customer_2002_apr_jul_channel_flags.count }
    filters: {
      field: customer_address.ca_county
      value: "Lycoming County,Sheridan County,Kandiyohi County,Pike County,Greene County"
    }
    filters: {
      field: customer.c_current_cdemo_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer_demographics.cd_demo_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer_2002_apr_jul_channel_flags.has_store_sales
      value: "Yes"
    }
    filters: {
      field: customer_2002_apr_jul_channel_flags.has_web_or_catalog_ship_sales
      value: "Yes"
    }
    sorts: [customer_demographics.cd_gender: asc]
  }
  assert: female_and_male_counts_match {
    expression: index(${customer_demographics.cd_gender}, 1) = "F"
      AND index(${customer.count}, 1) = 1
      AND index(${customer_demographics.cd_gender}, 2) = "M"
      AND index(${customer.count}, 2) = 2 ;;
  }
  assert: one_to_one_channel_flag_count_matches {
    expression: ${customer.count} = ${customer_2002_apr_jul_channel_flags.count} ;;
  }
}

test: customer_web_yoy_list_net_2001_2002_cohort_metrics {
  explore_source: customer {
    column: c_customer_id { field: customer.c_customer_id }
    column: total_web_2001_list_net_total { field: customer_channel_yoy_facts.total_web_2001_list_net_total }
    column: total_web_2002_list_net_total { field: customer_channel_yoy_facts.total_web_2002_list_net_total }
    column: web_list_net_yoy_ratio { field: customer_channel_yoy_facts.web_list_net_yoy_ratio }
    column: store_list_net_yoy_ratio { field: customer_channel_yoy_facts.store_list_net_yoy_ratio }
    filters: {
      field: customer_channel_yoy_facts.is_web_yoy_outpacing_store_list_net_2001_2002
      value: "Yes"
    }
    filters: {
      field: customer_channel_yoy_facts.c_customer_id
      value: "-NULL"
    }
    filters: {
      field: customer.c_customer_sk
      value: "<=20000"
    }
    sorts: [customer.c_customer_id: asc]
  }
  assert: cohort_customer_count_matches {
    expression: count(${customer.c_customer_id}) = 14 ;;
  }
  assert: web_2001_list_net_total_matches {
    expression: round(sum(${customer_channel_yoy_facts.total_web_2001_list_net_total}), 2) = 359304.63 ;;
  }
  assert: web_2002_list_net_total_matches {
    expression: round(sum(${customer_channel_yoy_facts.total_web_2002_list_net_total}), 2) = 572828.98 ;;
  }
  assert: web_yoy_exceeds_store_yoy {
    expression: ${customer_channel_yoy_facts.web_list_net_yoy_ratio} > ${customer_channel_yoy_facts.store_list_net_yoy_ratio} ;;
  }
}

test: customer_2001_q1_q3_multichannel_tx_demographics_metrics {
  explore_source: customer {
    column: cd_gender { field: customer_demographics.cd_gender }
    column: count { field: customer.count }
    column: channel_flag_count { field: customer_2001_q1_q3_channel_flags.count }
    filters: {
      field: customer_address.ca_state
      value: "TX"
    }
    filters: {
      field: customer.c_current_addr_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer_address.ca_address_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer.c_current_cdemo_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer_demographics.cd_demo_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer_2001_q1_q3_channel_flags.has_store_sales
      value: "Yes"
    }
    filters: {
      field: customer_2001_q1_q3_channel_flags.has_web_or_catalog_ship_sales
      value: "Yes"
    }
    sorts: [customer_demographics.cd_gender: asc]
  }
  assert: tx_female_and_male_counts_match {
    expression: index(${customer_demographics.cd_gender}, 1) = "F"
      AND index(${customer.count}, 1) = 230
      AND index(${customer_demographics.cd_gender}, 2) = "M"
      AND index(${customer.count}, 2) = 188 ;;
  }
  assert: one_to_one_channel_flag_count_matches {
    expression: ${customer.count} = ${customer_2001_q1_q3_channel_flags.count} ;;
  }
}
