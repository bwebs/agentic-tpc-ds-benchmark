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
