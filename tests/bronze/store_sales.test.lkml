include: "../../silver/explores/store_sales.explore.lkml"

test: store_sales_date_sk_2451911_metrics {
  explore_source: store_sales {
    column: total_extended_discount_amount { field: store_sales.total_extended_discount_amount }
    column: count { field: store_sales.count }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "2451911"
    }
  }
  assert: total_extended_discount_amount_matches {
    expression: round(${store_sales.total_extended_discount_amount}, 2) = 577179.83 ;;
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 3142 ;;
  }
}
