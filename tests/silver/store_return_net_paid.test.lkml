include: "../../gold/explores/store_return_net_paid.explore.lkml"

test: store_return_net_paid_market_8_papaya_metrics {
  explore_source: store_return_net_paid {
    column: count { field: store_return_net_paid.count }
    column: paid { field: store_return_net_paid.paid }
    column: is_above_5pct_avg_netpaid { field: store_return_net_paid.is_above_5pct_avg_netpaid }
    filters: {
      field: store_return_net_paid.market_id_filter
      value: "8"
    }
    filters: {
      field: store_return_net_paid.i_color
      value: "papaya"
    }
  }
  assert: row_count_matches {
    expression: ${store_return_net_paid.count} = 44 ;;
  }
  assert: paid_and_threshold_match {
    expression: round(${store_return_net_paid.paid}, 2) = -427473.20
      AND ${store_return_net_paid.is_above_5pct_avg_netpaid} = no ;;
  }
}
