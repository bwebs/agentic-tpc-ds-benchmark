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

test: store_sales_date_sk_2451666_net_profit_metrics {
  explore_source: store_sales {
    column: total_net_profit { field: store_sales.total_net_profit }
    column: count { field: store_sales.count }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "2451666"
    }
  }
  assert: total_net_profit_matches {
    expression: round(${store_sales.total_net_profit}, 2) = -744576.27 ;;
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 868 ;;
  }
}

test: store_sales_jan_1999_quantity_buckets {
  explore_source: store_sales {
    column: qty_1_20_count { field: store_sales.qty_1_20_count }
    column: qty_1_20_avg_ext_list_price { field: store_sales.qty_1_20_avg_ext_list_price }
    column: qty_1_20_avg_net_profit { field: store_sales.qty_1_20_avg_net_profit }
    column: bucket1 { field: store_sales.bucket1 }
    column: qty_21_40_count { field: store_sales.qty_21_40_count }
    column: bucket2 { field: store_sales.bucket2 }
    column: qty_41_60_count { field: store_sales.qty_41_60_count }
    column: bucket3 { field: store_sales.bucket3 }
    column: qty_61_80_count { field: store_sales.qty_61_80_count }
    column: bucket4 { field: store_sales.bucket4 }
    column: qty_81_100_count { field: store_sales.qty_81_100_count }
    column: bucket5 { field: store_sales.bucket5 }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "[2451180, 2451210]"
    }
  }
  assert: qty_1_20_count_matches {
    expression: ${store_sales.qty_1_20_count} = 6108 ;;
  }
  assert: qty_1_20_avg_ext_list_price_matches {
    expression: round(${store_sales.qty_1_20_avg_ext_list_price}, 2) = 811.27 ;;
  }
  assert: qty_1_20_avg_net_profit_matches {
    expression: round(${store_sales.qty_1_20_avg_net_profit}, 2) = -177.76 ;;
  }
  assert: bucket1_matches {
    expression: round(${store_sales.bucket1}, 2) = 811.27 ;;
  }
  assert: qty_21_40_count_matches {
    expression: ${store_sales.qty_21_40_count} = 6303 ;;
  }
  assert: bucket2_matches {
    expression: round(${store_sales.bucket2}, 2) = 2292.86 ;;
  }
  assert: qty_41_60_count_matches {
    expression: ${store_sales.qty_41_60_count} = 6399 ;;
  }
  assert: bucket3_matches {
    expression: round(${store_sales.bucket3}, 2) = -802.46 ;;
  }
  assert: qty_61_80_count_matches {
    expression: ${store_sales.qty_61_80_count} = 6404 ;;
  }
  assert: bucket4_matches {
    expression: round(${store_sales.bucket4}, 2) = -1134.13 ;;
  }
  assert: qty_81_100_count_matches {
    expression: ${store_sales.qty_81_100_count} = 6295 ;;
  }
  assert: bucket5_matches {
    expression: round(${store_sales.bucket5}, 2) = -1467.16 ;;
  }
}

test: store_sales_date_2451911_ext_sales_wholesale_metrics {
  explore_source: store_sales {
    column: average_ext_sales_price { field: store_sales.average_ext_sales_price }
    column: average_ext_wholesale_cost { field: store_sales.average_ext_wholesale_cost }
    column: total_ext_wholesale_cost { field: store_sales.total_ext_wholesale_cost }
    column: count { field: store_sales.count }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "2451911"
    }
  }
  assert: average_ext_sales_price_matches {
    expression: round(${store_sales.average_ext_sales_price}, 2) = 1892.35 ;;
  }
  assert: average_ext_wholesale_cost_matches {
    expression: round(${store_sales.average_ext_wholesale_cost}, 2) = 2551.61 ;;
  }
  assert: total_ext_wholesale_cost_matches {
    expression: round(${store_sales.total_ext_wholesale_cost}, 2) = 7797723.96 ;;
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 3142 ;;
  }
}
