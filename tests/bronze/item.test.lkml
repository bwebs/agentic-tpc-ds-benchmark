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

test: item_apparel_spec_slice_metrics {
  explore_source: item {
    column: is_apparel_spec_match { field: item.is_apparel_spec_match }
    column: item_count { field: item.count }
    filters: {
      field: item.i_item_sk
      value: "<=5000"
    }
    sorts: [item.is_apparel_spec_match: asc]
  }
  assert: non_matching_count_matches {
    expression: index(${item.is_apparel_spec_match}, 1) = no AND index(${item.count}, 1) = 4998 ;;
  }
  assert: matching_count_matches {
    expression: index(${item.is_apparel_spec_match}, 2) = yes AND index(${item.count}, 2) = 2 ;;
  }
}
