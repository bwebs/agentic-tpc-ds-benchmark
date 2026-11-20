include: "../../gold/explores/cross_channel_store_sales_yoy.explore.lkml"

test: cross_channel_store_sales_yoy_2001_q64_metrics {
  explore_source: cross_channel_store_sales_yoy {
    column: item_sk { field: cross_channel_store_sales_yoy.item_sk }
    column: product_name { field: cross_channel_store_sales_yoy.product_name }
    column: store_name { field: cross_channel_store_sales_yoy.store_name }
    column: store_zip { field: cross_channel_store_sales_yoy.store_zip }
    column: syear { field: cross_channel_store_sales_yoy.syear }
    column: cnt { field: cross_channel_store_sales_yoy.cnt }
    column: wholesale_cost_1 { field: cross_channel_store_sales_yoy.wholesale_cost_1 }
    column: list_price_1 { field: cross_channel_store_sales_yoy.list_price_1 }
    column: coupon_amt_1 { field: cross_channel_store_sales_yoy.coupon_amt_1 }
    column: wholesale_cost_2 { field: cross_channel_store_sales_yoy.wholesale_cost_2 }
    column: list_price_2 { field: cross_channel_store_sales_yoy.list_price_2 }
    column: coupon_amt_2 { field: cross_channel_store_sales_yoy.coupon_amt_2 }
    column: comparison_syear { field: cross_channel_store_sales_yoy.comparison_syear }
    column: comparison_cnt { field: cross_channel_store_sales_yoy.comparison_cnt }
    column: count { field: cross_channel_store_sales_yoy.count }
    filters: {
      field: cross_channel_store_sales_yoy.syear
      value: "2001"
    }
    filters: {
      field: cross_channel_store_sales_yoy.i_color
      value: "cyan,peach,blush,frosted,powder,orange"
    }
    filters: {
      field: cross_channel_store_sales_yoy.i_current_price
      value: "[59, 68]"
    }
  }
  assert: item_795_2001_vs_2002_yoy_metrics_match {
    expression: ${cross_channel_store_sales_yoy.item_sk} = 795
      AND ${cross_channel_store_sales_yoy.product_name} = "antin station"
      AND ${cross_channel_store_sales_yoy.store_name} = "ation"
      AND ${cross_channel_store_sales_yoy.store_zip} = "31904"
      AND ${cross_channel_store_sales_yoy.syear} = 2001
      AND ${cross_channel_store_sales_yoy.cnt} = 1
      AND round(${cross_channel_store_sales_yoy.wholesale_cost_1}, 2) = 33.13
      AND round(${cross_channel_store_sales_yoy.list_price_1}, 2) = 63.60
      AND round(${cross_channel_store_sales_yoy.coupon_amt_1}, 2) = 0
      AND round(${cross_channel_store_sales_yoy.wholesale_cost_2}, 2) = 97.04
      AND round(${cross_channel_store_sales_yoy.list_price_2}, 2) = 112.56
      AND round(${cross_channel_store_sales_yoy.coupon_amt_2}, 2) = 15.11
      AND ${cross_channel_store_sales_yoy.comparison_syear} = 2002
      AND ${cross_channel_store_sales_yoy.comparison_cnt} = 1
      AND ${cross_channel_store_sales_yoy.count} = 1 ;;
  }
}
