include: "../../gold/explores/store_item_revenue_vs_store_avg.explore.lkml"

test: store_item_revenue_vs_store_avg_store_1_item_118_q65_metrics {
  explore_source: store_item_revenue_vs_store_avg {
    column: ss_store_sk { field: store_item_revenue_vs_store_avg.ss_store_sk }
    column: ss_item_sk { field: store_item_revenue_vs_store_avg.ss_item_sk }
    column: s_store_name { field: store.s_store_name }
    column: revenue { field: store_item_revenue_vs_store_avg.revenue }
    column: store_avg_item_revenue { field: store_item_revenue_vs_store_avg.store_avg_item_revenue }
    column: is_below_10pct_store_avg { field: store_item_revenue_vs_store_avg.is_below_10pct_store_avg }
    column: count { field: store_item_revenue_vs_store_avg.count }
    column: total_revenue { field: store_item_revenue_vs_store_avg.total_revenue }
    filters: {
      field: store_item_revenue_vs_store_avg.month_seq_filter
      value: "[1199, 1210]"
    }
    filters: {
      field: store_item_revenue_vs_store_avg.ss_store_sk
      value: "1"
    }
    filters: {
      field: store_item_revenue_vs_store_avg.ss_item_sk
      value: "118"
    }
    filters: {
      field: store.s_store_sk
      value: "NOT NULL"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
  }
  assert: store_1_item_118_revenue_and_store_avg_match {
    expression: ${store_item_revenue_vs_store_avg.ss_store_sk} = 1
      AND ${store_item_revenue_vs_store_avg.ss_item_sk} = 118
      AND ${store.s_store_name} = "ought"
      AND round(${store_item_revenue_vs_store_avg.revenue}, 2) = 7.69
      AND round(${store_item_revenue_vs_store_avg.store_avg_item_revenue}, 2) = 294.24
      AND ${store_item_revenue_vs_store_avg.is_below_10pct_store_avg} = yes
      AND ${store_item_revenue_vs_store_avg.count} = 1
      AND round(${store_item_revenue_vs_store_avg.total_revenue}, 2) = 7.69 ;;
  }
}
