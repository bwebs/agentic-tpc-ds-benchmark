include: "../../gold/explores/item_cumulative_web_vs_store_sales.explore.lkml"

test: item_cumulative_web_vs_store_sales_m1192_1203_item1_metrics {
  explore_source: item_cumulative_web_vs_store_sales {
    column: d_date { field: item_cumulative_web_vs_store_sales.d_date }
    column: web_sales { field: item_cumulative_web_vs_store_sales.web_sales }
    column: web_cumulative { field: item_cumulative_web_vs_store_sales.web_cumulative }
    column: store_cumulative { field: item_cumulative_web_vs_store_sales.store_cumulative }
    column: count { field: item_cumulative_web_vs_store_sales.count }
    filters: {
      field: item_cumulative_web_vs_store_sales.month_seq_filter
      value: "[1192, 1203]"
    }
    filters: {
      field: item_cumulative_web_vs_store_sales.item_sk
      value: "1"
    }
    filters: {
      field: item_cumulative_web_vs_store_sales.is_web_exceeding_store_cumulative
      value: "Yes"
    }
    sorts: [item_cumulative_web_vs_store_sales.d_date: asc]
  }
  assert: item_1_cumulative_crossover_rows_match {
    expression: ${item_cumulative_web_vs_store_sales.count} >= 1
      AND round(index(${item_cumulative_web_vs_store_sales.web_sales}, 1), 2) = 87.8
      AND round(index(${item_cumulative_web_vs_store_sales.web_cumulative}, 1), 2) = 87.8
      AND round(index(${item_cumulative_web_vs_store_sales.store_cumulative}, 1), 2) = 45.31
      AND round(index(${item_cumulative_web_vs_store_sales.web_cumulative}, 2), 2) = 94.28
      AND round(index(${item_cumulative_web_vs_store_sales.store_cumulative}, 2), 2) = 45.31 ;;
  }
}
