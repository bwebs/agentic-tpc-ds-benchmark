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
