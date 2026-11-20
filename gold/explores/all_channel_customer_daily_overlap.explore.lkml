include: "/gold/all_channel_customer_daily_overlap.view.lkml"

explore: all_channel_customer_daily_overlap {
  hidden: no
  label: "All Channel Customer Daily Overlap"
  view_name: all_channel_customer_daily_overlap
  tags: ["gold"]

  query: all_three_channels_same_day_customer_count_m1188_1199 {
    description: "Count of distinct (c_last_name, c_first_name, d_date) tuples purchasing across store, catalog, and web on the same day during month_seq 1188..1199"
    measures: [
      all_channel_customer_daily_overlap.count
    ]
    filters: [
      all_channel_customer_daily_overlap.d_month_seq: "[1188, 1199]",
      all_channel_customer_daily_overlap.distinct_channel_count: "3",
      all_channel_customer_daily_overlap.c_last_name: "-NULL",
      all_channel_customer_daily_overlap.c_first_name: "-NULL",
      all_channel_customer_daily_overlap.d_date: "NOT NULL"
    ]
    limit: 100
  }
}
