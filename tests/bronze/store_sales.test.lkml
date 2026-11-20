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

test: store_sales_date_2451149_average_pricing_metrics {
  explore_source: store_sales {
    column: average_quantity { field: store_sales.average_quantity }
    column: average_list_price { field: store_sales.average_list_price }
    column: average_coupon_amount { field: store_sales.average_coupon_amount }
    column: average_sales_price { field: store_sales.average_sales_price }
    column: count { field: store_sales.count }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "2451149"
    }
  }
  assert: average_quantity_matches {
    expression: round(${store_sales.average_quantity}, 2) = 50.43 ;;
  }
  assert: average_list_price_matches {
    expression: round(${store_sales.average_list_price}, 2) = 76.64 ;;
  }
  assert: average_coupon_amount_matches {
    expression: round(${store_sales.average_coupon_amount}, 2) = 196.22 ;;
  }
  assert: average_sales_price_matches {
    expression: round(${store_sales.average_sales_price}, 2) = 38.06 ;;
  }
  assert: count_matches {
    expression: ${store_sales.count} = 2849 ;;
  }
}
