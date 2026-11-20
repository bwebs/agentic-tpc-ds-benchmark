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

test: catalog_returns_q91_1999_call_center_demographics_join {
  explore_source: catalog_returns {
    column: total_net_loss { field: catalog_returns.total_net_loss }
    column: count { field: catalog_returns.count }
    column: customer_address_count { field: customer_address.count }
    filters: {
      field: call_center.cc_call_center_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_year_num
      value: "1999"
    }
    filters: {
      field: customer_demographics.marital_education_group_id
      value: "M: Unknown,W: Advanced Degree"
    }
    filters: {
      field: household_demographics.hd_buy_potential
      value: "Unknown%"
    }
  }
  assert: total_net_loss_matches {
    expression: round(${catalog_returns.total_net_loss}, 2) = 164424.41 ;;
  }
  assert: return_count_matches {
    expression: ${catalog_returns.count} = 247 ;;
  }
  assert: customer_address_joined {
    expression: ${customer_address.count} > 0 ;;
  }
}
