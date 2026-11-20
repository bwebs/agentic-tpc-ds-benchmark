include: "../../bronze/explores/item.explore.lkml"

test: item_catalog_slice_metrics {
  explore_source: item {
    column: item_count { field: item.count }
    column: average_current_price { field: item.average_current_price }
    filters: {
      field: item.i_item_sk
      value: "<=1000"
    }
  }
  assert: item_count_matches {
    expression: ${item.count} = 1000 ;;
  }
  assert: average_current_price_matches {
    expression: round(${item.average_current_price}, 2) = 9.75 ;;
  }
}
