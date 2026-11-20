include: "../../gold/explores/all_channel_item_color_sales.explore.lkml"

test: all_channel_item_color_sales_mar_1998_color_cohort_gmt6_metrics {
  explore_source: all_channel_item_color_sales {
    column: total_sales { field: all_channel_sales.total_sales }
    column: count { field: all_channel_sales.count }
    filters: [
      item_color_cohort.item_color_filter: "firebrick,rosy,white",
      item_color_cohort.is_in_color_cohort: "Yes",
      date_dim.d_year_num: "1998",
      date_dim.d_moy: "3",
      customer_address.ca_gmt_offset: "-6",
      all_channel_sales.item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      all_channel_sales.sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      all_channel_sales.addr_sk: "NOT NULL",
      customer_address.ca_address_sk: "NOT NULL"
    ]
  }
  assert: total_sales_matches {
    expression: round(${all_channel_sales.total_sales}, 2) = 3733033.24 ;;
  }
  assert: count_matches {
    expression: ${all_channel_sales.count} = 1777 ;;
  }
}
