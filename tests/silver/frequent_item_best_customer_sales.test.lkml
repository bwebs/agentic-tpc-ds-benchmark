include: "../../gold/explores/frequent_item_best_customer_sales.explore.lkml"

test: frequent_item_best_customer_sales_2000_cohort_metrics {
  explore_source: frequent_item_best_customer_sales {
    column: count { field: frequent_item_best_customer_sales.count }
    column: sum_sales { field: frequent_item_best_customer_sales.sum_sales }
    filters: {
      field: frequent_item_best_customer_sales.store_cohort_year_filter
      value: "2000"
    }
    filters: {
      field: date_dim.d_year_num
      value: "2000"
    }
  }
  assert: count_matches {
    expression: ${frequent_item_best_customer_sales.count} = 8 ;;
  }
  assert: sum_sales_matches {
    expression: round(${frequent_item_best_customer_sales.sum_sales}, 2) = 23699.59 ;;
  }
}

test: frequent_item_best_customer_sales_jun_1998_null_guard {
  explore_source: frequent_item_best_customer_sales {
    column: count { field: frequent_item_best_customer_sales.count }
    column: sum_sales { field: frequent_item_best_customer_sales.sum_sales }
    filters: {
      field: frequent_item_best_customer_sales.store_cohort_year_filter
      value: "1998,1999,2000,2001"
    }
    filters: {
      field: date_dim.d_year_num
      value: "1998"
    }
    filters: {
      field: date_dim.d_moy
      value: "6"
    }
  }
  assert: zero_row_null_sales_matches {
    expression: ${frequent_item_best_customer_sales.count} = 0 AND is_null(${frequent_item_best_customer_sales.sum_sales}) ;;
  }
}
