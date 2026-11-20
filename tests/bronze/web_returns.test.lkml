include: "../../silver/explores/web_returns.explore.lkml"

test: web_returns_date_sk_2451545_metrics {
  explore_source: web_returns {
    column: total_return_amount { field: web_returns.total_return_amount }
    column: count { field: web_returns.count }
    filters: {
      field: web_returns.wr_returned_date_sk
      value: "2451545"
    }
  }
  assert: total_return_amount_matches {
    expression: round(${web_returns.total_return_amount}, 2) = 32668.44 ;;
  }
  assert: return_count_matches {
    expression: ${web_returns.count} = 34 ;;
  }
}

test: web_returns_date_sk_2451545_refund_fee_averages {
  explore_source: web_returns {
    column: average_refunded_cash { field: web_returns.average_refunded_cash }
    column: average_fee { field: web_returns.average_fee }
    column: count { field: web_returns.count }
    filters: {
      field: web_returns.wr_returned_date_sk
      value: "2451545"
    }
  }
  assert: average_refunded_cash_matches {
    expression: round(${web_returns.average_refunded_cash}, 2) = 425.93 ;;
  }
  assert: average_fee_matches {
    expression: round(${web_returns.average_fee}, 2) = 50.74 ;;
  }
  assert: return_count_matches {
    expression: ${web_returns.count} = 34 ;;
  }
}
