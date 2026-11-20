include: "../../silver/explores/all_channel_sales.explore.lkml"

test: all_channel_sales_2001_d2451911_metrics {
  explore_source: all_channel_sales {
    column: count { field: all_channel_sales.count }
    column: total_year_net_amount { field: all_channel_sales.total_year_net_amount }
    column: store_2001_year_total { field: all_channel_sales_customer_date_dim_fields.store_2001_year_total }
    column: catalog_2001_year_total { field: all_channel_sales_customer_date_dim_fields.catalog_2001_year_total }
    column: web_2001_year_total { field: all_channel_sales_customer_date_dim_fields.web_2001_year_total }
    filters: {
      field: date_dim.d_date_sk
      value: "2451911"
    }
  }
  assert: row_count_matches {
    expression: ${all_channel_sales.count} = 4558 ;;
  }
  assert: total_year_net_amount_matches {
    expression: round(${all_channel_sales.total_year_net_amount}, 2) = 6424548.39 ;;
  }
  assert: store_2001_year_total_matches {
    expression: round(${all_channel_sales_customer_date_dim_fields.store_2001_year_total}, 3) = 4453990.675 ;;
  }
  assert: catalog_2001_year_total_matches {
    expression: round(${all_channel_sales_customer_date_dim_fields.catalog_2001_year_total}, 2) = 672646.59 ;;
  }
  assert: web_2001_year_total_matches {
    expression: round(${all_channel_sales_customer_date_dim_fields.web_2001_year_total}, 3) = 1295002.265 ;;
  }
}

test: all_channel_sales_d2451911_distinct_channels {
  explore_source: all_channel_sales {
    column: distinct_channel_count { field: all_channel_sales.distinct_channel_count }
    filters: {
      field: date_dim.d_date_sk
      value: "2451911"
    }
  }
  assert: distinct_channel_count_matches {
    expression: ${all_channel_sales.distinct_channel_count} = 3 ;;
  }
}

test: all_channel_sales_week_5330_channel_revenue_metrics {
  explore_source: all_channel_sales {
    column: ss_item_rev { field: all_channel_sales.ss_item_rev }
    column: cs_item_rev { field: all_channel_sales.cs_item_rev }
    column: ws_item_rev { field: all_channel_sales.ws_item_rev }
    column: average_channel_rev { field: all_channel_sales.average_channel_rev }
    column: ss_dev { field: all_channel_sales.ss_dev }
    column: is_balanced_across_channels { field: all_channel_sales.is_balanced_across_channels }
    filters: {
      field: date_dim.d_week_seq
      value: "5330"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
  }
  assert: ss_item_rev_matches {
    expression: round(${all_channel_sales.ss_item_rev}, 2) = 10739950.46 ;;
  }
  assert: cs_item_rev_matches {
    expression: round(${all_channel_sales.cs_item_rev}, 2) = 8037174.28 ;;
  }
  assert: ws_item_rev_matches {
    expression: round(${all_channel_sales.ws_item_rev}, 2) = 3976165.70 ;;
  }
  assert: average_channel_rev_matches {
    expression: round(${all_channel_sales.average_channel_rev}, 2) = 7584430.15 ;;
  }
  assert: ss_dev_matches {
    expression: round(${all_channel_sales.ss_dev}, 4) = 15.7339 ;;
  }
  assert: is_balanced_across_channels_matches {
    expression: ${all_channel_sales.is_balanced_across_channels} = no ;;
  }
}
