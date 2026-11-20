include: "../../silver/explores/store_returns.explore.lkml"

test: store_returns_2001_tn_join_metrics {
  explore_source: store_returns {
    column: total_return_amount { field: store_returns.total_return_amount }
    column: count { field: store_returns.count }
    filters: {
      field: date_dim.d_year_num
      value: "2001"
    }
    filters: {
      field: store.s_state
      value: "TN"
    }
  }
  assert: total_return_amount_matches {
    expression: round(${store_returns.total_return_amount}, 2) = 52573797.19 ;;
  }
  assert: return_count_matches {
    expression: ${store_returns.count} = 54476 ;;
  }
}
