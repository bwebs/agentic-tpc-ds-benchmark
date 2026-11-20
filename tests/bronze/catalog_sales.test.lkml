include: "../../silver/explores/catalog_sales.explore.lkml"

test: catalog_sales_date_sk_2450829_metrics {
  explore_source: catalog_sales {
    column: total_sales_price { field: catalog_sales.total_sales_price }
    column: count { field: catalog_sales.count }
    filters: {
      field: catalog_sales.cs_sold_date_sk
      value: "2450829"
    }
  }
  assert: total_sales_price_matches {
    expression: round(${catalog_sales.total_sales_price}, 2) = 21213.11 ;;
  }
  assert: catalog_sales_count_matches {
    expression: ${catalog_sales.count} = 436 ;;
  }
}
