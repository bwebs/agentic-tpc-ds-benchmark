include: "../../silver/explores/catalog_returns.explore.lkml"

test: catalog_returns_1999_tx_join_metrics {
  explore_source: catalog_returns {
    column: total_return_amt_inc_tax { field: catalog_returns.total_return_amt_inc_tax }
    column: count { field: catalog_returns.count }
    filters: {
      field: date_dim.d_year_num
      value: "1999"
    }
    filters: {
      field: returning_address.ca_state
      value: "TX"
    }
  }
  assert: total_return_amt_inc_tax_matches {
    expression: round(${catalog_returns.total_return_amt_inc_tax}, 2) = 3060502.39 ;;
  }
  assert: return_count_matches {
    expression: ${catalog_returns.count} = 2222 ;;
  }
}
