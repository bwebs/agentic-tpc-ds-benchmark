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
