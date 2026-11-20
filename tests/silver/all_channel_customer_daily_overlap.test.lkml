include: "../../gold/explores/all_channel_customer_daily_overlap.explore.lkml"

test: all_channel_customer_daily_overlap_m1188_1199_metrics {
  explore_source: all_channel_customer_daily_overlap {
    column: distinct_channel_count { field: all_channel_customer_daily_overlap.distinct_channel_count }
    column: count { field: all_channel_customer_daily_overlap.count }
    filters: [
      all_channel_customer_daily_overlap.d_month_seq: "[1188, 1199]",
      all_channel_customer_daily_overlap.c_last_name: "-NULL",
      all_channel_customer_daily_overlap.c_first_name: "-NULL",
      all_channel_customer_daily_overlap.d_date: "NOT NULL"
    ]
    sorts: [all_channel_customer_daily_overlap.distinct_channel_count: desc]
  }
  assert: two_channel_overlap_matches {
    expression: index(${all_channel_customer_daily_overlap.distinct_channel_count}, 1) = 2 AND index(${all_channel_customer_daily_overlap.count}, 1) = 127 ;;
  }
  assert: single_channel_count_matches {
    expression: index(${all_channel_customer_daily_overlap.distinct_channel_count}, 2) = 1 AND index(${all_channel_customer_daily_overlap.count}, 2) = 86104 ;;
  }
}

test: all_channel_customer_daily_overlap_m1188_1199_three_channels {
  explore_source: all_channel_customer_daily_overlap {
    column: count { field: all_channel_customer_daily_overlap.count }
    filters: [
      all_channel_customer_daily_overlap.d_month_seq: "[1188, 1199]",
      all_channel_customer_daily_overlap.distinct_channel_count: "3",
      all_channel_customer_daily_overlap.c_last_name: "-NULL",
      all_channel_customer_daily_overlap.c_first_name: "-NULL",
      all_channel_customer_daily_overlap.d_date: "NOT NULL"
    ]
  }
  assert: three_channel_overlap_is_zero {
    expression: ${all_channel_customer_daily_overlap.count} = 0 ;;
  }
}
