include: "../../silver/explores/catalog_sales.explore.lkml"

test: catalog_sales_order_le_100_metrics {
  explore_source: catalog_sales {
    column: order_count { field: catalog_sales.order_count }
    column: distinct_warehouse_count { field: catalog_sales.distinct_warehouse_count }
    column: total_shipping_cost { field: catalog_sales.total_shipping_cost }
    column: total_net_profit { field: catalog_sales.total_net_profit }
    filters: [catalog_sales.cs_order_number: "<=100"]
  }
  assert: order_count_matches {
    expression: ${catalog_sales.order_count} = 100 ;;
  }
  assert: distinct_warehouse_count_matches {
    expression: ${catalog_sales.distinct_warehouse_count} = 5 ;;
  }
  assert: total_shipping_cost_matches {
    expression: round(${catalog_sales.total_shipping_cost}, 2) = 996073.72 ;;
  }
  assert: total_net_profit_matches {
    expression: round(${catalog_sales.total_net_profit}, 2) = -162397.57 ;;
  }
}

test: catalog_sales_order_le_100_average_pricing_metrics {
  explore_source: catalog_sales {
    column: average_quantity { field: catalog_sales.average_quantity }
    column: average_list_price { field: catalog_sales.average_list_price }
    column: average_coupon_amount { field: catalog_sales.average_coupon_amount }
    column: average_sales_price { field: catalog_sales.average_sales_price }
    column: average_net_profit { field: catalog_sales.average_net_profit }
    column: count { field: catalog_sales.count }
    filters: [catalog_sales.cs_order_number: "<=100"]
  }
  assert: average_quantity_matches {
    expression: round(${catalog_sales.average_quantity}, 2) = 49.64 ;;
  }
  assert: average_list_price_matches {
    expression: round(${catalog_sales.average_list_price}, 2) = 96.97 ;;
  }
  assert: average_coupon_amount_matches {
    expression: round(${catalog_sales.average_coupon_amount}, 2) = 243.81 ;;
  }
  assert: average_sales_price_matches {
    expression: round(${catalog_sales.average_sales_price}, 2) = 48.75 ;;
  }
  assert: average_net_profit_matches {
    expression: round(${catalog_sales.average_net_profit}, 2) = -188.83 ;;
  }
  assert: count_matches {
    expression: ${catalog_sales.count} = 860 ;;
  }
}
