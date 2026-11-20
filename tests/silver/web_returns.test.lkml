include: "../../silver/explores/web_returns.explore.lkml"

test: web_returns_2000_in_join_metrics {
  explore_source: web_returns {
    column: total_return_amount { field: web_returns.total_return_amount }
    column: count { field: web_returns.count }
    filters: {
      field: date_dim.d_year_num
      value: "2000"
    }
    filters: {
      field: returning_address.ca_state
      value: "IN"
    }
  }
  assert: total_return_amount_matches {
    expression: round(${web_returns.total_return_amount}, 2) = 500504.95 ;;
  }
  assert: return_count_matches {
    expression: ${web_returns.count} = 373 ;;
  }
}
