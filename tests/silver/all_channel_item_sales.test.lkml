include: "../../silver/explores/all_channel_item_sales.explore.lkml"

test: all_channel_item_sales_nov_2001_cat1_metrics {
  explore_source: all_channel_item_sales {
    column: count { field: all_channel_item_sales.count }
    column: total_gross_list_sales { field: all_channel_item_sales.total_gross_list_sales }
    column: average_gross_list_sales { field: all_channel_item_sales.average_gross_list_sales }
    column: distinct_channel_count { field: all_channel_item_sales.distinct_channel_count }
    filters: {
      field: date_dim.d_year_num
      value: "2001"
    }
    filters: {
      field: date_dim.d_moy
      value: "11"
    }
    filters: {
      field: item.i_category_id
      value: "1"
    }
  }
  assert: count_matches {
    expression: ${all_channel_item_sales.count} = 15708 ;;
  }
  assert: total_gross_list_sales_matches {
    expression: round(${all_channel_item_sales.total_gross_list_sales}, 2) = 67044010.76 ;;
  }
  assert: average_gross_list_sales_matches {
    expression: round(${all_channel_item_sales.average_gross_list_sales}, 2) = 4367.12 ;;
  }
  assert: distinct_channel_count_matches {
    expression: ${all_channel_item_sales.distinct_channel_count} = 3 ;;
  }
}
