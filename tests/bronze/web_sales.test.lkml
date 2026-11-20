include: "../../silver/explores/web_sales.explore.lkml"

test: web_sales_date_sk_2451676_metrics {
  explore_source: web_sales {
    column: total_ext_sales_price { field: web_sales.total_ext_sales_price }
    column: count { field: web_sales.count }
    filters: {
      field: web_sales.ws_sold_date_sk
      value: "2451676"
    }
  }
  assert: total_ext_sales_price_matches {
    expression: round(${web_sales.total_ext_sales_price}, 2) = 539842.27 ;;
  }
  assert: web_sales_count_matches {
    expression: ${web_sales.count} = 224 ;;
  }
}

test: web_sales_date_sk_2451676_sales_price_metrics {
  explore_source: web_sales {
    column: total_sales_price { field: web_sales.total_sales_price }
    column: count { field: web_sales.count }
    filters: {
      field: web_sales.ws_sold_date_sk
      value: "2451676"
    }
  }
  assert: total_sales_price_matches {
    expression: round(${web_sales.total_sales_price}, 2) = 11215.87 ;;
  }
  assert: web_sales_count_matches {
    expression: ${web_sales.count} = 224 ;;
  }
}

test: web_sales_ship_date_sk_2452000_2452100_aging_metrics {
  explore_source: web_sales {
    column: days_30 { field: web_sales.days_30 }
    column: days_31_60 { field: web_sales.days_31_60 }
    column: days_61_90 { field: web_sales.days_61_90 }
    column: days_91_120 { field: web_sales.days_91_120 }
    column: days_over_120 { field: web_sales.days_over_120 }
    filters: {
      field: web_sales.ws_ship_date_sk
      value: "[2452000, 2452100]"
    }
  }
  assert: days_30_matches {
    expression: ${web_sales.days_30} = 5872 ;;
  }
  assert: days_31_60_matches {
    expression: ${web_sales.days_31_60} = 5999 ;;
  }
  assert: days_61_90_matches {
    expression: ${web_sales.days_61_90} = 5830 ;;
  }
  assert: days_91_120_matches {
    expression: ${web_sales.days_91_120} = 8278 ;;
  }
  assert: days_over_120_matches {
    expression: ${web_sales.days_over_120} = 0 ;;
  }
}

test: web_sales_date_sk_2451676_average_quantity_metrics {
  explore_source: web_sales {
    column: average_quantity { field: web_sales.average_quantity }
    column: count { field: web_sales.count }
    filters: {
      field: web_sales.ws_sold_date_sk
      value: "2451676"
    }
  }
  assert: average_quantity_matches {
    expression: round(${web_sales.average_quantity}, 2) = 50.12 ;;
  }
  assert: web_sales_count_matches {
    expression: ${web_sales.count} = 224 ;;
  }
}

test: web_sales_date_sk_2451911_net_paid_metrics {
  explore_source: web_sales {
    column: total_net_paid { field: web_sales.total_net_paid }
    column: count { field: web_sales.count }
    filters: {
      field: web_sales.ws_sold_date_sk
      value: "2451911"
    }
  }
  assert: total_net_paid_matches {
    expression: round(${web_sales.total_net_paid}, 2) = 2264574.08 ;;
  }
  assert: web_sales_count_matches {
    expression: ${web_sales.count} = 970 ;;
  }
}

test: web_sales_q92_date_sk_2452363_ext_discount_metrics {
  explore_source: web_sales {
    column: total_ext_discount_amt { field: web_sales.total_ext_discount_amt }
    column: average_ext_discount_amt { field: web_sales.average_ext_discount_amt }
    column: count { field: web_sales.count }
    filters: {
      field: web_sales.ws_sold_date_sk
      value: "2452363"
    }
  }
  assert: total_ext_discount_amt_matches {
    expression: round(${web_sales.total_ext_discount_amt}, 2) = 564162.92 ;;
  }
  assert: average_ext_discount_amt_matches {
    expression: round(${web_sales.average_ext_discount_amt}, 2) = 2496.3 ;;
  }
  assert: count_matches {
    expression: ${web_sales.count} = 226 ;;
  }
}

test: web_sales_order_le_100_q94_metrics {
  explore_source: web_sales {
    column: order_count { field: web_sales.order_count }
    column: distinct_warehouse_count { field: web_sales.distinct_warehouse_count }
    column: total_shipping_cost { field: web_sales.total_shipping_cost }
    column: total_net_profit { field: web_sales.total_net_profit }
    filters: [web_sales.ws_order_number: "<=100"]
  }
  assert: order_count_matches {
    expression: ${web_sales.order_count} = 100 ;;
  }
  assert: distinct_warehouse_count_matches {
    expression: ${web_sales.distinct_warehouse_count} = 5 ;;
  }
  assert: total_shipping_cost_matches {
    expression: round(${web_sales.total_shipping_cost}, 2) = 1458547.43 ;;
  }
  assert: total_net_profit_matches {
    expression: round(${web_sales.total_net_profit}, 2) = -263638.45 ;;
  }
}
