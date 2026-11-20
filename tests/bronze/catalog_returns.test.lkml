include: "../../silver/explores/catalog_returns.explore.lkml"

test: catalog_returns_date_sk_2451180_metrics {
  explore_source: catalog_returns {
    column: total_return_amt_inc_tax { field: catalog_returns.total_return_amt_inc_tax }
    column: count { field: catalog_returns.count }
    filters: {
      field: catalog_returns.cr_returned_date_sk
      value: "2451180"
    }
  }
  assert: total_return_amt_inc_tax_matches {
    expression: round(${catalog_returns.total_return_amt_inc_tax}, 2) = 122440.60 ;;
  }
  assert: return_count_matches {
    expression: ${catalog_returns.count} = 81 ;;
  }
}

test: catalog_returns_q91_date_sk_2451180_net_loss {
  explore_source: catalog_returns {
    column: total_net_loss { field: catalog_returns.total_net_loss }
    column: count { field: catalog_returns.count }
    filters: {
      field: catalog_returns.cr_returned_date_sk
      value: "2451180"
    }
  }
  assert: total_net_loss_matches {
    expression: round(${catalog_returns.total_net_loss}, 2) = 63787.47 ;;
  }
  assert: return_count_matches {
    expression: ${catalog_returns.count} = 81 ;;
  }
}
