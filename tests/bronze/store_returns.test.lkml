include: "../../silver/explores/store_returns.explore.lkml"

test: store_returns_date_sk_2451911_metrics {
  explore_source: store_returns {
    column: total_return_amount { field: store_returns.total_return_amount }
    column: count { field: store_returns.count }
    filters: {
      field: store_returns.sr_returned_date_sk
      value: "2451911"
    }
  }
  assert: total_return_amount_matches {
    expression: round(${store_returns.total_return_amount}, 2) = 177765.93 ;;
  }
  assert: return_count_matches {
    expression: ${store_returns.count} = 205 ;;
  }
}
