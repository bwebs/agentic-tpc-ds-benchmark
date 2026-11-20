include: "../../gold/explores/all_channel_manufacturer_category_sales.explore.lkml"

test: all_channel_manufacturer_category_sales_mar_1999_books_gmt5_metrics {
  explore_source: all_channel_manufacturer_category_sales {
    column: total_ext_sales_price { field: all_channel_sales.total_ext_sales_price }
    column: count { field: all_channel_sales.count }
    filters: [
      manufacturer_category_cohort.manufacturer_category_filter: "Books",
      manufacturer_category_cohort.is_in_category_cohort: "Yes",
      date_dim.d_year_num: "1999",
      date_dim.d_moy: "3",
      customer_address.ca_gmt_offset: "-5",
      all_channel_sales.item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      all_channel_sales.sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      all_channel_sales.addr_sk: "NOT NULL",
      customer_address.ca_address_sk: "NOT NULL"
    ]
  }
  assert: total_ext_sales_price_matches {
    expression: round(${all_channel_sales.total_ext_sales_price}, 2) = 30651057.59 ;;
  }
  assert: count_matches {
    expression: ${all_channel_sales.count} = 14031 ;;
  }
}
